extends Node2D
class_name ChessPiece

@onready var sprite_2d: Sprite2D = $Sprite2D

var animals: Array = [
	preload("res://assets/textures/animals/crocodile.png"),
	preload("res://assets/textures/animals/bear.png"),
	preload("res://assets/textures/animals/panda.png"),
	preload("res://assets/textures/animals/penguin.png"),
	preload("res://assets/textures/animals/cow.png")
]
var tween: Tween

## 棋子类型
var piece_type: int = 0 :
	set(value):
		if sprite_2d != null and value < 5:
			sprite_2d.texture = animals[value]
			piece_type = value


## 选中棋子
func selected() -> void:
	tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(self, "scale", Vector2(0.5, 0.5), 0.2)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)


## 取消选中
func deselected() -> void:
	if tween:
		tween.kill()
	tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	


## 棋子移动到目标格子
func move_to(target_cell: Cell) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", target_cell.position, 0.1)
	await tween.finished
