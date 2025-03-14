extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var marker_2d: Marker2D = $Marker2D
@onready var sling_band_left: Line2D = $SlingBandLeft
@onready var sling_band_right: Line2D = $SlingBandRight
@onready var slingshot: Sprite2D = $Slingshot
@onready var camera_2d: Camera2D = $Camera2D

##最大拉伸距离
@export var max_stretch_distance: float = 120.0
##抛物线点数量
@export var max_points: int = 20
##抛物线初始速度
@export var init_velocity_factor: float = 10

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var start_position: Vector2
var drag_position: Vector2 = Vector2.ZERO
var can_drag = false:
	set(value):
		can_drag = value
		sling_band_left.visible = can_drag
		sling_band_right.visible = can_drag
		slingshot.visible = can_drag

const point_texture = preload("res://asserts/textures/point.png")
var bullet_s: PackedScene = preload("res://src/entities/bullet.tscn")		
var points = []
var bullet = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 输入事件
	area_2d.input_event.connect(_on_area_2d_input_event)
	start_position = marker_2d.position
	setup_points()
	bullet = bullet_s.instantiate()
	marker_2d.add_child(bullet)
	bullet.gravity_scale = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_drag:
		_update_sling_shot()
		update_trajectory()
	update_camera()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if can_drag:
			lunch()
			can_drag = false
			drag_position = start_position
			# 隐藏线路轨迹
			for p in points:
				p.visible = false

func lunch() -> void:
	bullet.gravity_scale = 1.0 # 重力
	bullet.linear_velocity = _get_lanuch_velocity()

## 移动摄像机
func update_camera() -> void:
	if not bullet: return
	if bullet.linear_velocity.length() > 10:
		camera_2d.global_position = bullet.global_position

## 更新抛物线
func update_trajectory() -> void:
	var init_v = _get_lanuch_velocity()
	var time_step = 0.1
	var total_time = 2.0
	var cur_time = 0.0
	var index = 0
	while cur_time <= total_time and index < max_points:
		# y轴 需要重力参与计算
		var local = Vector2(
			start_position.x + init_v.x * cur_time,
			start_position.y + init_v.y * cur_time + (gravity * cur_time))
		points[index].global_position = to_global(local)
		points[index].visible = true
		cur_time += time_step
		index += 1
	
	for i in range(index, max_points):
		points[i].visible = false

## 初始化抛物线
func setup_points() -> void:
	for i in range(max_points):
		var point = Sprite2D.new()
		point.texture = point_texture
		point.visible = false
		points.append(point)
		add_child(point)

func _get_lanuch_velocity() -> Vector2:
	return (start_position - drag_position) * init_velocity_factor

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
	var offset = Vector2(-25, 15)
	sling_band_left.points[1] = drag_position + offset
	sling_band_right.points[1] = drag_position + offset
	slingshot.position = drag_position + offset
	# 子弹位置
	bullet.global_position = to_global(drag_position)


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			can_drag = true
		else:
			can_drag = false
			drag_position = start_position
			# 隐藏线路轨迹
			for p in points:
				p.visiable = false
