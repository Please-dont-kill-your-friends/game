extends Node

signal received_username(id: int, username: String)

@rpc("any_peer", "call_remote", "reliable")
func client_send_username(username: String):
	var id: int = multiplayer.get_remote_sender_id()
	received_username.emit(id, username)
	pass

@rpc("authority", "call_remote", "reliable")
func server_send_bg_color(_bg_color: Color):
	pass
