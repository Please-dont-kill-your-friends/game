extends Node

signal ice_candidate_received(media: String, index: int, p_name: String, id: int)

var rtc_mtp: WebRTCMultiplayerPeer = WebRTCMultiplayerPeer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	rtc_mtp.create_server()
	multiplayer.multiplayer_peer = rtc_mtp
	
	ice_candidate_received.connect(_on_ice_candidate_received)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func create_peer(type: String, sdp: String, id: int):
	var peer: WebRTCPeerConnection = WebRTCPeerConnection.new()
	
	peer.initialize({
		"iceServers": [
			{
				"urls": [ "stun:49.13.224.243:10523" ], # One or more STUN servers.
			},
			{
				"urls": [ "turn:49.13.224.243:10523" ], # One or more TURN servers.
				"username": "test", # Optional username for the TURN server.
				"credential": "test123", # Optional password for the TURN server.
			}
		]
	})
	
	peer.session_description_created.connect(_on_session_description_created.bind(id))
	peer.ice_candidate_created.connect(_on_ice_candidate_created.bind(id))
	
	rtc_mtp.add_peer(peer, id)
	peer.set_remote_description(type, sdp)
	pass

func _on_session_description_created(type: String, sdp: String, id: int):
	_get_peer(id).set_local_description(type, sdp)
	WebSocketMessage.msg_send_answer(type, sdp, id)
	pass

func _on_ice_candidate_created(media: String, index: int, p_name: String, id: int):
	WebSocketMessage.msg_send_candidate(media, index, p_name, id)
	pass

func _on_ice_candidate_received(media: String, index: int, p_name: String, id: int):
	_get_peer(id).add_ice_candidate(media, index, p_name)
	pass

func _get_peer(id: int) -> WebRTCPeerConnection:
	return rtc_mtp.get_peer(id).connection
