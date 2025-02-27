extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var sling_band_left: Line2D = $SlingBandLeft
@onready var sling_band_right: Line2D = $SlingBandRight
@onready var slingshot: Sprite2D = $Slingshot
# 最大拉伸距离
@export var max_stretch_distance: float = 120.0

var start_position: Vector2
var drag_position: Vector2 = Vector2.ZERO
var can_drag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 输入事件
	area_2d.input_event.connect(_on_area_2d_input_event)
	start_position = marker_2d.position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_drag:
		_update_sling_shot()


## 更新弹弓皮筋
func _update_sling_shot() -> void:
	var local_mouse_position = get_local_mouse_position()
	var stretch_v = local_mouse_position - start_position #拉伸量
	# 限制最大拉伸长度
	stretch_v = stretch_v if stretch_v.length() < max_stretch_distance else stretch_v.normalized() * max_stretch_distance
	# 限制反方向
	if stretch_v.x > -50:
		stretch_v.x = -50
	drag_position = start_position + stretch_v
	# 改变 皮筋第二个点 位置
	sling_band_left.points[1] = drag_position
	sling_band_right.points[1] = drag_position
	slingshot.position = drag_position


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			can_drag = true
		else:
			can_drag = false
