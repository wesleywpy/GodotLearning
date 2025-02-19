extends Node2D

@onready var timer: Timer = $Timer
@onready var score_timer: Timer = $ScoreTimer
@onready var plane: CharacterBody2D = $Plane
@onready var game_form: GameForm = $GameForm

@export var s_rock: PackedScene
@export var min_spawn_rock_time: float = 1.0
@export var max_spawn_rock_time: float = 3.0

var current_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = randf_range(min_spawn_rock_time, max_spawn_rock_time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not plane:
		return
	if plane.position.y < 0 or plane.position.y > get_viewport_rect().size.y:
		game_over()


func game_over() -> void:
	print("Game Over...")
	get_tree().quit()

func _on_timer_timeout() -> void:
	spawn_rock()
	timer.wait_time = randf_range(min_spawn_rock_time, max_spawn_rock_time)
	timer.start()


func spawn_rock() -> void:
	var rock: Node2D = s_rock.instantiate()
	rock.rock_entered.connect(_on_rock_entered)
	var r: int = randi_range(0, 1)
	
	if r == 0:
		# 方向朝上 x位置固定
		rock.position = Vector2(640, randf_range(210, 360))
	else:
		rock.rotation_degrees = 180 # 旋转180° 方向朝下
		rock.position = Vector2(640, randf_range(-30, 150))
	self.add_child(rock)


func _on_rock_entered() -> void:
	game_over()


# 分数计时器
func _on_score_timer_timeout() -> void:
	current_score += 1
	game_form.update_score_display(current_score)
