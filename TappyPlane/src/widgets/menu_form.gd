extends Control
class_name MenuForm

signal btn_new_game_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


## new game 按钮
func _on_new_game_button_pressed() -> void:
	print("_on_new_game_button_pressed")
	btn_new_game_pressed.emit()
