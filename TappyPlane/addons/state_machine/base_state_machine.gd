extends Node
class_name BaseStateMachine

## 状态机代理对象
@export var agent: Node

## 当前状态
var current_state: BaseState = null
## 所有状态
var states: Dictionary = {}
## 是否在运行
var is_run: bool = false
## 状态机参数集合
var params: Dictionary = {}


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

## 启动状态机
func launch(state_type: int = 0) -> void:
	assert(agent, '代理不能空!')
	self.current_state = states[state_type]
	self.current_state.enter()

## 切换状态
func transition_to(state_type: int, msg: Dictionary = {}) -> void:
	self.current_state.exit()
	self.current_state = states[state_type]
	self.current_state.enter(msg)

## 添加状态
func add_state(state_type: int, state: BaseState) -> void:
	states[state_type] = state

## 删除状态
func remove_state(state_type: int) -> void:
	states.erase(state_type)

## 根据名称获取属性的值
func get_variable(name: StringName) -> Variant:
	if params.has(name):
		return params[name]
	return null

## 根据名称设置属性的值
func set_variable(name : StringName, value : Variant) -> void:
	params[name] = value

## 是否存在属性
func has_variable(name: StringName) -> bool:
	return params.has(name)
