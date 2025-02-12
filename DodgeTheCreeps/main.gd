extends Node

@export var mob_scen: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass #new_game()


# 从 Player 发出 信号
func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()
	

func new_game() -> void:
	# call_group() 会调用
	get_tree().call_group("mobs", "queue_free") #清理旧的小怪
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()


func _on_score_timer_timeout() -> void:
	# 加分计时器
	score += 1
	$HUD.update_score(score)


func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()


func _on_mob_timer_timeout() -> void:
	var mob = mob_scen.instantiate() # 实例化mob
	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress = randi() # 移动位置

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position
	# PI表示转半圈的弧度
	var direction = mob_spawn_location.rotation + PI / 2
	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# 150.0 和 250.0 之间选取随机值 设置速度
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)
