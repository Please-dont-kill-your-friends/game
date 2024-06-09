extends Node

# Enum of all Message Types that can be send
enum MessageType{
	Id,
	Join,
	UserConnected,
	UserDisconnected,
	Lobby,
	Candidate,
	Offer,
	Answer,
	CheckIn
}

# Receives the message and processes it based on it's message type
func handle_message(message: String):
	var data: Dictionary = JSON.parse_string(message)
	var type: MessageType = int(data["type"])
	
	print("Empfangen: " + message)
	
	match type:
		MessageType.Lobby:
			_handle_lobby_msg(data)
		MessageType.Offer:
			_handle_offer_msg(data)
		MessageType.Candidate:
			_handle_candidate_msg(data)
	pass

# Build JSON strings to send to the server
func _build_message(type: MessageType, payload: Dictionary = {}, id: int = -1) -> String:
	var message = {
		"type": type,
		"room_code": LobbyManager.room_code,
		"id": id,
		"server": true,
		"payload": payload
	}
	return JSON.stringify(message)

# Send Message
func _send_message(message: String):
	WebSocketConnection.socket.send_text(message)
	
	print("Gesendet:  " + message)
	pass

# Handle each type of message the game can receive
func _handle_lobby_msg(data: Dictionary):
	var room_code: String = data.room_code
	print("Received unique room code %s." % [room_code])
	LobbyManager.received_room_code.emit(room_code)

func _handle_offer_msg(data: Dictionary):
	WebRTCConnection.create_peer(data.payload.type, data.payload.sdp, int(data.id))
	pass

func _handle_candidate_msg(data: Dictionary):
	WebRTCConnection.ice_candidate_received.emit(data.payload.media, data.payload.index, data.payload.name, int(data.id))
	pass

# Predefined functions to make the way of building messages easier
func msg_open_lobby() -> void:
	var message = _build_message(MessageType.Lobby)
	_send_message(message)
	pass

func msg_send_answer(type: String, sdp: String, id: int) -> void:
	var message: String = _build_message(MessageType.Answer, { "type": type, "sdp": sdp }, id)
	_send_message(message)
	pass

func msg_send_candidate(media: String, index: int, p_name: String, id: int) -> void:
	var message: String = _build_message(MessageType.Candidate, { "media": media, "index": index, "name": p_name }, id)
	_send_message(message)
	pass
