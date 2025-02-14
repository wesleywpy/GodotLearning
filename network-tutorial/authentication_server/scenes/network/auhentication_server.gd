extends Node

@export_range(1025,65536) var port: int = 1911
@export_range(2, 1024) var max_clients: int = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func startup() -> void:
	var network = ENetMultiplayerPeer.new()
	# 创建Server
	var ret = network.create_server(port, max_clients)
	if ret == OK:
		get_multiplayer().set_multiplayer_peer(network)
		print("Server started on port %d, allowing max %d connections" % [port, max_clients])
		
		# lambda表达式
		network.peer_connected.connect(
			func(client_id: int) -> void : print("Client %d connected" % client_id)
		)
		network.peer_disconnected.connect(
			func(client_id: int) -> void : print("Client %d disconnected" % client_id)
		)
	else:
		print("Error while starting server: %d" % ret)
		get_tree().quit(ret)
