extends ParallaxBackground

@onready var parallax_layer: ParallaxLayer = $ParallaxLayer

#滚动速度
@export var speed: float = 180

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 重新加载初始化偏移量
	parallax_layer.motion_offset = Vector2.ZERO


# Called every frame. 'delta' 上一帧到当前帧所经过的时间（以秒为单位）.
func _process(delta: float) -> void:
	# 防止数据溢出
	if parallax_layer.motion_offset.x <= parallax_layer.motion_mirroring.x * -1:
		parallax_layer.motion_offset.x = 0
	#delta * speed 计算出一帧应该移动的距离。通过在每一帧都进行这样的计算和移动，就形成了连续滚动的效果。
	parallax_layer.motion_offset.x -= delta * speed
	#print(parallax_layer.motion_offset.x)
