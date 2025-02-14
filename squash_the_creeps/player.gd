extends CharacterBody3D

signal hit

# 速度 m/s
@export var speed:int = 14
# 下落加速度
@export var fall_acceleration:int = 75
@export var jump_impulse:int = 20

@export var bounce_impulse:int = 16

#Vector3 组合了速度和方向的3D向量
var target_velocity:Vector3 = Vector3.ZERO


func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1 #3D场景中 z轴表示 地平线
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# 设置方向
		$Pivot.basis = Basis.looking_at(direction)
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	
	if not is_on_floor():
		# 不在地面, 朝地面下落
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	elif is_on_floor() and Input.is_action_just_pressed("jump"):
		# 在地面上 则可以跳跃
		target_velocity.y = jump_impulse
	
	# 遍历所有碰撞信息
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		
		# 是否在 mob group 里面
		if collision.get_collider().is_in_group("mob"):
			var mob = collision.get_collider()
			#是不是降落在怪物身上。碰撞法线（normal）是垂直于碰撞平面的 3D 向量。
			if Vector3.UP.dot(collision.get_normal()) > 0.1 :
				mob.squash()
				target_velocity.y = bounce_impulse
				break
	# 移动角色
	velocity = target_velocity
	move_and_slide()


func die() -> void:
	hit.emit() #发出被击中信号
	queue_free()

func _on_mob_detector_body_entered(body: Node3D) -> void:
	die()
