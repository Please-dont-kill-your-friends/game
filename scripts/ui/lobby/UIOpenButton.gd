extends Button

func _on_pressed():
	WebSocketConnection.connect_to_signaling_server()
	disabled = true
	pass
