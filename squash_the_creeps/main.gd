extends Node

@export var mob_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	add_child(mob)


func _on_player_hit() -> void:
	$MobTimer.stop()
