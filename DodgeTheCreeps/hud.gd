extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func show_message(text: String) -> void:
	$Message.text = text
	$Message.show()
	$MessageTimer.start()


func show_game_over() -> void:
	show_message("Game Over")
	await $MessageTimer.timeout #等待MessageTimer超时
	$Message.text = "Dodge the Creeps!"
	$Message.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show() #延迟1秒


func update_score(score) -> void:
	$ScoreLabel.text = str(score) #更新分数显示文本


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit() #触发开始游戏的signal


func _on_message_timer_timeout() -> void:
	$Message.hide()
