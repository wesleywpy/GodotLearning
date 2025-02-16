extends CharacterBody3D

signal squashed

@export var min_speed :int = 10
@export var max_speed :int = 18


func _physics_process(delta: float) -> void:
	move_and_slide()


# 小怪初始位置start_position 以及玩家的位置player_position 
func initialize(start_position : Vector3, player_position : Vector3) -> void :
	# start_position 朝向 player_position
	look_at_from_position(start_position, player_position, Vector3.UP)
	# 旋转y轴 取随机值
	rotate_y(randf_range(-PI / 4 , PI / 4))
	var random_speed = randi_range(min_speed, max_speed)
	# 速度
	velocity = Vector3.FORWARD * random_speed
	velocity = velocity.rotated(Vector3.UP, rotation.y)
	$AnimationPlayer.speed_scale = random_speed / min_speed #播放速度


func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()
	

func squash():
	squashed.emit()
	queue_free()
