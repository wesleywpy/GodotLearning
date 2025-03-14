extends Node2D

#@onready var game_form: GameForm = %GameForm
#@onready var menu_form: MenuForm = $UILayer/MenuForm
@onready var parallax_background: ParallaxBackground = %ParallaxBackground
@onready var game_state_machine: GameStateMachine = %GameStateMachine
@onready var ui_manager: UIManager = %UIManager

@export var min_spawn_rock_time: float = 1.0
@export var max_spawn_rock_time: float = 3.0

var plane: CharacterBody2D
var rock_timer: Timer = Timer.new()
var score_timer: Timer = Timer.new()
var s_rock: PackedScene = preload("res://src/entities/rock.tscn")
var s_plane: PackedScene = preload("res://src/entities/plane.tscn")
var current_score: int = 0 
var current_ui: Control:
	get:
		return ui_manager.current_interface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ui_manager:
		ui_manager = %UIManager
	#retry_game()
	#game_form.quit_pressed.connect(_on_game_form_quit_pressed)
	#game_form.retry_pressed.connect(_on_game_form_retry_pressed)
	ui_manager.subscribe(MenuForm.singal_new_game, _on_menu_form_btn_new_game_pressed)
	ui_manager.subscribe(MenuForm.singal_quit_game, _on_menu_form_btn_quit_game_pressed)
	#menu_form.btn_new_game_pressed.connect(_on_menu_form_btn_new_game_pressed)
	game_state_machine.launch()

func init_game() -> void:
	pass

# 准备游戏
func ready_game() -> void:
	if not ui_manager:
		ui_manager = %UIManager
	ui_manager.open_interface("menu_form")  #打开菜单框

# 新的一局游戏
func new_game() -> void:
	game_state_machine.set_variable('is_new_game', true)

## 退出游戏
func quit_game() -> void:
	game_state_machine.set_variable('is_quit_game', true)

# 结束游戏
func end_game() -> void:
	get_tree().quit()


# 重试游戏
func retry_game() -> void:
	if not plane:
		plane = s_plane.instantiate()
		plane.position = Vector2(90, 130)
		self.add_child(plane)
	current_score = 0
	ui_manager.open_interface("game_form")
	current_ui.update_score_display(current_score)
	#game_form.update_score_display(current_score)
	#game_form.retry_game()
	# 石头 Timer
	rock_timer.wait_time = randf_range(min_spawn_rock_time, max_spawn_rock_time)
	rock_timer.timeout.connect(_on_timer_timeout)
	rock_timer.one_shot = true
	self.add_child(rock_timer)
	rock_timer.start()
	# 分数 Timer
	score_timer.wait_time = 1
	score_timer.timeout.connect(_on_score_timer_timeout)
	self.add_child(score_timer)
	score_timer.start()
	parallax_background.retry_game()

 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not plane:
		return
	if plane.position.y < 0 or plane.position.y > get_viewport_rect().size.y:
		game_over()


func game_over() -> void:
	print("Game Over...")
	plane.queue_free()
	rock_timer.stop()
	score_timer.stop()
	#game_form.game_over()
	# 清空飞机和石头
	plane.queue_free()
	for rock in get_tree().get_nodes_in_group("rock"):
		rock.queue_free()


func _on_timer_timeout() -> void:
	spawn_rock()
	rock_timer.wait_time = randf_range(min_spawn_rock_time, max_spawn_rock_time)
	rock_timer.start()


func spawn_rock() -> void:
	var rock: Rock = s_rock.instantiate()
	var r: int = randi_range(0, 1)
	
	if r == 0:
		# 方向朝上 x位置固定
		rock.position = Vector2(640, randf_range(325, 450))
	else:
		rock.rotation_degrees = 180 # 旋转180° 方向朝下
		rock.position = Vector2(640, randf_range(-130, -50))
	rock.rock_entered.connect(_on_rock_entered)
	self.add_child(rock)


func _on_rock_entered() -> void:
	game_over()


# 分数计时器
func _on_score_timer_timeout() -> void:
	current_score += 1
	#game_form.update_score_display(current_score)

## 退出按钮事件
func _on_game_form_quit_pressed() -> void:
	print("quit")
	get_tree().quit()


## 重试按钮事件
func _on_game_form_retry_pressed() -> void:
	print("retry")
	retry_game()

func _on_menu_form_btn_new_game_pressed() -> void:
	new_game()

func _on_menu_form_btn_quit_game_pressed() -> void:
	quit_game()
