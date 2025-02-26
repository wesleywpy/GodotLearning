extends Node2D
class_name Cell

# 被点击 信号
signal pressed(cell: Cell)
# 棋子被改变 信号
signal piece_changed(cell: Cell, piece: ChessPiece)

# Cell在棋盘中坐标
var coordinate: Vector2i = Vector2i.ZERO
var default_bg_color := Color.html("#17314d")
var hight_light_color := Color.LIGHT_CYAN

# 当前网格包含的棋子
var piece: ChessPiece = null :
	set(value):
		if piece != null:
			self.remove_child(piece)
		if value != null:
			self.add_child(value)
		piece = value
		# 发出 piece_changed 信号
		piece_changed.emit(self, piece)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 输入事件绑定
	$Area2D.input_event.connect(_on_area_2d_input_event)


func hight_light() -> void:
	$ColorRect.color = hight_light_color


func cancel_hight_light() -> void:
	$ColorRect.color = default_bg_color


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		# 鼠标左键 并且 被按下
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			pressed.emit(self)
