extends Node

signal received_username(id: int, username: String)
signal received_vector_input(id: int, vector: Vector2)
signal received_button_a(id: int)
signal received_button_b(id: int)

@rpc("any_peer", "call_remote", "reliable")
func client_send_username(username: String):
	received_username.emit(multiplayer.get_remote_sender_id(), username)
	pass

@rpc("any_peer", "call_remote", "unreliable")
func client_send_joystick_input(vector: Vector2):
	received_vector_input.emit(multiplayer.get_remote_sender_id(), vector)
	pass


@rpc("any_peer", "call_remote", "unreliable")
func client_send_button_a_input():
	received_button_a.emit(multiplayer.get_remote_sender_id())
	pass

@rpc("any_peer", "call_remote", "unreliable")
func client_send_button_b_input():
	received_button_b.emit(multiplayer.get_remote_sender_id())
	pass

@rpc("authority", "call_remote", "reliable")
func server_send_bg_color(_bg_color: Color):
	pass

@rpc("authority", "call_remote", "reliable")
func sever_set_controller_joystick():
	pass

@rpc("authority", "call_remote", "reliable")
func server_disable_button_a(_disabled: bool):
	pass

@rpc("authority", "call_remote", "reliable")
func server_disable_button_b(_disabled: bool):
	pass

@rpc("authority", "call_remote", "reliable")
func server_send_ranking(_rank: int, _points: int):
	pass
