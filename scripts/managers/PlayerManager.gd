extends Node

signal player_joined(player: Player)

var used_colors: Array[ColorManager.COLORS] = [] 
var players: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	CommunicationManager.received_username.connect(_on_received_username)
	pass 

func _on_received_username(id: int, username: String):
	var player: Player = Player.new()
	var color = ColorManager.get_unique_color()
	player.color = color
	player.username = username
	players[id] = player
	CommunicationManager.server_send_bg_color.rpc_id(id, ColorManager.get_color(color))
	player_joined.emit(player)
	pass
