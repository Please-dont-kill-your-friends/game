extends Control

var open_scene: PackedScene = load("res://scenes/lobby/Open.tscn")
var opened_scene: PackedScene = load("res://scenes/lobby/Opened.tscn")

var open_instance: Node
var opened_instance: Node

func _ready():
	WebSocketConnection.connected_to_server.connect(_on_connected_to_server)
	
	open_instance = open_scene.instantiate()
	add_child(open_instance)
	pass

func _on_connected_to_server():
	open_instance.queue_free()
	opened_instance = opened_scene.instantiate()
	add_child(opened_instance)
	pass
