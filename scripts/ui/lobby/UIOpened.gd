extends Control

var lobby_player_scene: PackedScene = load("res://scenes/lobby/LobbyPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	LobbyManager.received_room_code.connect(_on_received_room_code)
	PlayerManager.player_joined.connect(_on_player_joined)
	pass

func _on_received_room_code(room_code: String):
	$WelcomeLabel.text += room_code + "!"
	pass

func _on_player_joined(player: Player):
	var lobby_player_instance: Node = lobby_player_scene.instantiate()
	lobby_player_instance.get_child(1).modulate = ColorManager.get_color(player.color)
	lobby_player_instance.get_child(2).text = player.username
	$PlayerContainer.add_child(lobby_player_instance)
	pass
