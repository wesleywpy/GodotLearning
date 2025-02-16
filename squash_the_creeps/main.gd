extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$UserInterface/Retry.hide()
	pass # Replace with function body.


func _on_mob_timer_timeout() -> void:
	var mob = mob_scene.instantiate()
	# 获取Node
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.progress_ratio = randf() # 随机位置
	var player_position = $Player.position
	# 小怪朝向玩家
	mob.initialize(mob_spawn_location.position, player_position)

	# Spawn the mob by adding it to the Main scene.
	# 绑定mob销毁的回调函数 -> $UserInterface/ScoreLabel._on_mob_squashed()
	mob.squashed.connect($UserInterface/ScoreLabel._on_mob_squashed.bind())
	add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
	$UserInterface/Retry.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and $UserInterface/Retry.visible:
		get_tree().reload_current_scene() # 重新加载scene
