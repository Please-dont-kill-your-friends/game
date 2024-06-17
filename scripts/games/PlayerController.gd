extends CharacterBody2D
class_name PlayerController

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	CommunicationManager.received_vector_input.connect(_on_received_vector_input)
	CommunicationManager.received_button_a.connect(_on_received_button_a)
	CommunicationManager.received_button_b.connect(_on_received_button_b)
	pass 

func _on_received_vector_input(id: int, vec: Vector2):
	if PlayerManager.locked: return
	if self.player.id != id: return
	_received_vector(vec)
	pass

func _on_received_button_a(id: int):
	if PlayerManager.locked: return
	if self.player.id != id: return
	_received_button_a()
	pass

func _on_received_button_b(id: int):
	if PlayerManager.locked: return
	if self.player.id != id: return
	_received_button_b()
	pass

func _received_vector(_vec: Vector2):
	pass

func _received_button_a():
	pass

func _received_button_b():
	pass
