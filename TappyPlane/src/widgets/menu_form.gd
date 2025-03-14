extends UIForm
class_name MenuForm

@onready var margin_container: MarginContainer = $BackgroundContainer/MarginContainer

## 开始按钮信号
const singal_new_game: StringName = "menu_form_new_game"
const singal_quit_game: StringName = "menu_form_quit_game"

## new game 按钮
func _on_new_game_button_pressed() -> void:
	print("_on_new_game_button_pressed")
	ui_manager.emit(singal_new_game, [])

## 退出按钮 
func _on_btn_quit_pressed() -> void:
	print("_on_btn_quit_pressed")
	ui_manager.emit(singal_quit_game, [])
