extends CharacterBody2D
class_name Rock

@onready var area_2d: Area2D = $Area2D

signal rock_entered
const SPEED = 200.0

func _ready() -> void:
	# 绑定事件
	area_2d.area_entered.connect(_on_area_2d_body_entered)
	print("even body_entered connected!")

func _physics_process(delta: float) -> void:
	self.velocity.x = SPEED * -1 # 每一帧向左移动
	move_and_slide()
	# 位置在屏幕之外 销毁当前Node
	if self.position.x < -150: 
		self.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("crashed!")
	rock_entered.emit()
