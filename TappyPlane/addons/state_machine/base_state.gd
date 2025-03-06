extends RefCounted
class_name BaseState

## 当前状态所属的状态机
var state_machine = null
var agent: Node = null:
	get:
		assert(state_machine and state_machine.agent, '状态机或代理不存在!')
		return state_machine.agent

## 构造函数
func _init(machine: BaseStateMachine) -> void:
	state_machine = machine

## 抽象方法: 进入当前状态执行的操作
func enter(_msg: Dictionary = {}) -> void:
	pass

## 退出
func exit() -> void:
	pass

## 当前状态: 逐帧调用方法
func update(delta: float) -> void:
	pass

## 当前状态下逐物理帧调用的方法
func physics_update(delta: float) -> void:
	pass

## 切换状态，这个方法调用状态机同名方法，提供方便
func transition_to(state_index: int, msg: Dictionary = {}) -> void:
	state_machine.transition_to(state_index, msg)

## 获取状态机参数
func get_fsm_variable(key) -> Variant:
	return state_machine.get_variable(key)

func set_fsm_variable(key, value) -> void:
	state_machine.set_variable(key, value)

## 判断是否存在状态机参数
func has_fsm_variable(key) -> bool:
	return state_machine.has_variable(key)
