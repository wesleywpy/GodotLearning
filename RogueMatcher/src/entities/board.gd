extends Node2D

var cell_scene: PackedScene = preload("res://src/entities/cell.tscn")
var piece_scene: PackedScene = preload("res://src/entities/piece.tscn")

const rows: int = 9
const cols: int = 9

var cell_size: Vector2 = Vector2(70,70)
#网格间隙
@export var grid_gap: Vector2 = Vector2.ONE

var a_star: AStarGrid2D = AStarGrid2D.new()


#棋盘当前被选中的棋子
var selected_piece: ChessPiece = null:
	set(value):
		if selected_piece:
			selected_piece.deselected() # 释放
		if value:
			value.selected()
		selected_piece = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_board()
	spawn_random_pieces(3)


## 初始化棋盘
func initialize_board() -> void:
	# 寻路网格 区域大小和棋盘保持一致
	a_star.region.size = Vector2i(cols, rows)
	# 禁止对角线移动
	a_star.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	a_star.update()
	for i in rows:
		for j in cols:
			var cell: Cell = cell_scene.instantiate()
			cell.position = Vector2(i * (cell_size.x+grid_gap.x), j * (cell_size.y + grid_gap.y))
			cell.coordinate = Vector2i(i,j) # 格子坐标
			self.add_child(cell) 
			cell.pressed.connect(_on_cell_pressed)
			cell.piece_changed.connect(
				func(c: Cell, p: ChessPiece) -> void :
					# 设置寻路
					a_star.set_point_solid(c.coordinate, p != null)
			)

 
# 随机生成棋子
func spawn_random_pieces(times: int) -> void:
	for i in times:
		spawn_piece()


func spawn_piece() -> void:
	# 棋盘上随机格子
	var coordinate: Vector2i = Vector2i(randi_range(0, rows-1), randi_range(0, cols-1))
	if has_piece(coordinate):
		# 递归查找没有棋子的格子
		self.spawn_piece()
		return
	var cell: Cell = _find_cell(coordinate)
	# 创建棋子
	var piece: ChessPiece = piece_scene.instantiate()
	cell.piece = piece
	piece.piece_type = randi_range(0, 4)


# 是否有棋子
func has_piece(coordinate: Vector2i) -> bool:
	var cell:Cell = _find_cell(coordinate)
	return cell.piece != null


func _find_cell(coordinate: Vector2i) -> Cell:
	# coordinate.x * cols 第几行 + 第几个
	var index = coordinate.x * cols + coordinate.y
	return self.get_child(index)


# coords: 路径中所有的坐标
func _find_cells(coords: PackedVector2Array) -> Array:
	var cells: Array = []
	for index in coords:
		cells.append(_find_cell(index))
	return cells


func move_selected_piece(target_cell: Cell) -> void:
	var cur_cell: Cell = selected_piece.get_parent()
	# 获取从起始坐标 到 目标坐标 之间的路径
	var path: PackedVector2Array = a_star.get_point_path(cur_cell.coordinate, target_cell.coordinate)
	if not path.is_empty():
		var cells: Array = _find_cells(path)
		# 每个格子高亮显示
		for c in cells:
			c.hight_light()
		cur_cell.piece = null # 当前格子的棋子置空
		self.add_child(selected_piece) # 当前棋子 暂存到 棋盘
		selected_piece.position = cur_cell.position # 位置为当前格子的位置
		#逐渐移动棋子
		for p in path:
			#等待执行完成
			await selected_piece.move_to(_find_cell(p))
		self.remove_child(selected_piece)
		target_cell.piece = selected_piece
		selected_piece.position = Vector2.ZERO #设置为0 跟随父节点
		
		for c in cells:
			c.cancel_hight_light()

	selected_piece = null


func _on_cell_pressed(cell: Cell) -> void :
	if cell.piece:
		# 格子上有棋子 则被中
		selected_piece = cell.piece 
	elif selected_piece != null:
		# 被选中的棋子 移动到 当前cell
		move_selected_piece(cell)
