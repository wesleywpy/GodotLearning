extends Node

@onready var auhentication_server: Node = $AuhenticationServer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().set_multiplayer(SceneMultiplayer.new(), ^"/root/Main/AuhenticationServer")
	auhentication_server.start_up()
