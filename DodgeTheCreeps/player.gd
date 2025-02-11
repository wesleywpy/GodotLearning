extends Area2D
signal hit

@export var speed = 400 # Player移动速度
var screen_size # 窗口大小


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide() #隐藏当前Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_leftt"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		
	if velocity.length() > 0:
		#对向量进行归一化就是将其长度缩减到 1
		velocity = velocity.normalized() * speed
		#$返回从当前节点开始的相对路径上的节点，如果找不到该节点，则返回 null。
		$AnimatedSprite2D.play() # 等同于get_node("AnimatedSprite2D") 
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	# 位置限制在给定范围之内
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0: # 水平移动
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false #垂直翻转
		$AnimatedSprite2D.flip_h = velocity.x < 0 # 水平翻转
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0


#当物体接触到玩家时就会发出这个信号。
func _on_body_entered(body: Node2D) -> void:
	hide() #Player被击中
	hit.emit() #发出信号
	$CollisionShape2D.set_deferred("disabled", true)


# 重置玩家
func start(pos: Vector2):
	position = pos
	show() #显示Node
	$CollisionShape2D.disabled = false
	
