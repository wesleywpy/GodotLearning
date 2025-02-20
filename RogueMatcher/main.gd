extends Node2D

var cell_scene: PackedScene = preload("res://src/entities/cell.tscn")

const rows: int = 9
const cols: int = 9

var cell_size: Vector2 = Vector2(68,68)
#网格间隙
@export var grid_gap: Vector2 = Vector2.ONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_board()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func initialize_board() -> void:
	for i in rows:
		for j in cols:
			var cell = cell_scene.instantiate()
			cell.position = Vector2(i * (cell_size.x+grid_gap.x), j * (cell_size.y + grid_gap.y))
			print(cell.position)
			self.add_child(cell)
