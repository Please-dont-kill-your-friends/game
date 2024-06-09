extends Node

signal received_room_code(code: String)

var room_code: String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	received_room_code.connect(_on_received_room_code)
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_received_room_code(code: String):
	room_code = code
	pass
