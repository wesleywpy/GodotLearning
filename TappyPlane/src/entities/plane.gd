extends CharacterBody2D

# 重力
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var min_tilt_angle: int = -45
@export var max_tilt_angle: int = 45
## 向上拍打的力
@export var flap_power = 300
## y方向最大速度
@export var max_velocity_y: int = 200

func _physics_process(delta: float) -> void:
	# Add the gravity.
	velocity.y += gravity * delta # 物体在垂直方向（通常是Y轴）上的速度
	
	# 得到一个与速度相关的倾斜角度
	var tilt_angle = velocity.y / gravity * max_tilt_angle
	# 限制 tilt_angle 最大角度为max_tilt_angle
	self.rotation_degrees = clamp(tilt_angle, -360, max_tilt_angle)
	
	move_and_slide()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("flap"):
		flap()


func flap() -> void:
	var _y = self.velocity.y - flap_power # 向上移动
	self.velocity.y = clamp(_y, max_velocity_y * -1, max_velocity_y)
