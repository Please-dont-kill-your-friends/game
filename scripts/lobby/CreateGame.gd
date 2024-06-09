extends Control

func _ready():
	LobbyManager.received_room_code.connect(_on_received_room_code)
	WebRTCConnection.rtc_mtp.peer_connected.connect(_on_peer_connected)
	pass

func _on_open_lobby_button_pressed():
	WebSocketConnection.connect_to_signaling_server()
	$OpenLobby.visible = false
	pass 

func _on_received_room_code(code: String):
	$LobbyOpened/RoomCode.text = code
	$LobbyOpened.visible = true
	pass

func _on_peer_connected(id: int):
	$LobbyOpened/ItemList.add_item(str(id), null, false)
	pass
