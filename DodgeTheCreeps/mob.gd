extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 获取动画名称列表
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation_names())
	$AnimatedSprite2D.animation = mob_types.pick_random()
	$AnimatedSprite2D.play()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free() #删除当前Node
