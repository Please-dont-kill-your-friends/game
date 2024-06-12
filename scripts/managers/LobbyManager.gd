extends Node

signal received_room_code(code: String)

var room_code: String = ""

func _ready():
	received_room_code.connect(_on_received_room_code)
	pass 

func _on_received_room_code(code: String):
	room_code = code
	pass
