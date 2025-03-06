extends CanvasLayer
class_name UIManager

"""
管理和协调所有UI元素和UI界面。
提供方法来打开、关闭、或切换UI窗口。
可能还需要管理UI资源和配置，以及处理UI相关的事件和输入。
"""

@export var ui_path : String = "res://src/widgets/"

var current_interface: UIBase:
	get:
		return self.get_child(-1) #最后一个

## 根据名称创建UI界面
func create_interface(name: StringName) -> Control:
	var widget_path: String = ui_path + name + ".tscn"
	assert(ResourceLoader.exists(widget_path), "UI资源路径不识别! " % widget_path)
	var control = load(widget_path).instantiate()
	if "interface_name" in control:
		control.interface_name = name
	return control

## 根据名称获取UI界面
func get_interface(ui_name: StringName) -> UIBase:
	for interface in get_children():
		if interface.interface_name == ui_name:
			return interface
	return null

## 打开界面
func open_interface(ui_name: StringName, msg: Dictionary = {}) -> UIBase:
	# 当前组件存在则隐藏
	if current_interface:
		current_interface.hide()
	var interface = get_interface(ui_name)
	if interface:
		# 移动到最后
		self.move_child(interface, -1)
	else:
		interface = create_interface(ui_name)
		self.add_child(interface)
	interface._opened(msg)
	interface.show()
	return interface

## 关闭当前界面
func close_current_interface() -> void:
	var interface = current_interface
	self.remove_child(interface)
	interface._closed()
	interface.queue_free()
	#current_interface.show()

## 触发信号
func emit(dest_singal: StringName, payload) -> void:
	if not payload is Array:
		payload = [payload]
	# 信号名 放在最前面
	payload.insert(0, _get_or_add_singal(dest_singal))
	# 反射调用 emit_signal 方法
	callv("emit_signal", payload)

## 绑定信号 回调方法
func subscribe(dest_singal: String, callback: Callable) -> void:
	var singal_name: StringName = _get_or_add_singal(dest_singal)
	if not is_connected(singal_name, callback):
		connect(singal_name, callback)

## 解绑信号
func unsubscribe(dest_singal: String, callback: Callable) -> void:
	var singal_name: StringName = _get_or_add_singal(dest_singal)
	if is_connected(singal_name, callback):
		disconnect(singal_name, callback)


## 获取或者添加信号
func _get_or_add_singal(dest_singal: String) -> StringName:
	var singal_name: StringName = "EventBus|%" % dest_singal
	if not has_user_signal(singal_name):
		add_user_signal(singal_name)
	return singal_name
