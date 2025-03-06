extends Control
class_name GameForm

@onready var score_container: HBoxContainer = $ScoreContainer
@onready var quit_button: TextureButton = $GameOverPop/MarginContainer/VBoxContainer/HBoxContainer/QuitButton
@onready var retry_button: TextureButton = $GameOverPop/MarginContainer/VBoxContainer/HBoxContainer/RetryButton
@onready var game_over_pop: MarginContainer = $GameOverPop

signal quit_pressed
signal retry_pressed

const num_map: Dictionary = {
	"0": preload("res://assets/textures/widgets/numbers/number0.png"),
	"1": preload("res://assets/textures/widgets/numbers/number1.png"),
	"2": preload("res://assets/textures/widgets/numbers/number2.png"),
	"3": preload("res://assets/textures/widgets/numbers/number3.png"),
	"4": preload("res://assets/textures/widgets/numbers/number4.png"),
	"5": preload("res://assets/textures/widgets/numbers/number5.png"),
	"6": preload("res://assets/textures/widgets/numbers/number6.png"),
	"7": preload("res://assets/textures/widgets/numbers/number7.png"),
	"8": preload("res://assets/textures/widgets/numbers/number8.png"),
	"9": preload("res://assets/textures/widgets/numbers/number9.png")
}

func _ready() -> void:
	quit_button.pressed.connect(_on_quit_button_pressed)
	retry_button.pressed.connect(_on_retry_button_pressed)
	game_over_pop.hide()

func retry_game() -> void:
	game_over_pop.hide()

func game_over() -> void:
	game_over_pop.show()

# 更新显示分数
func update_score_display(score: int) -> void:
	#移除当前所有子Node
	for child in score_container.get_children():
		score_container.remove_child(child)

	var score_str = str(score)
	for char in score_str:
		var num_texture:TextureRect = TextureRect.new()
		num_texture.texture = num_map[char]
		score_container.add_child(num_texture)


func _on_quit_button_pressed() -> void:
	#print("_on_quit_button_pressed")
	quit_pressed.emit()


func _on_retry_button_pressed() -> void:
	#print("_on_retry_button_pressed")
	retry_pressed.emit()
