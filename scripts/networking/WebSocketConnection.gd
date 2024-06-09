extends Node

const SERVER_IP: String = "49.13.224.243"
const SERVER_PORT: int = 5072

signal connected_to_server()
signal connection_closed()

var socket: WebSocketPeer = WebSocketPeer.new()
var started_connection: bool = false
var last_state = WebSocketPeer.STATE_CLOSED

func _ready():
	socket.set_supported_protocols(PackedStringArray(["pdkyf"]))
	connected_to_server.connect(_on_connected_to_server)
	pass 

func _process(_delta):
	# Don't start polling if connectipon is not initialized yet
	if started_connection:
		_poll_connection()
	pass

func _poll_connection():
	# Poll connection
	socket.poll()
	var state = socket.get_ready_state()
	_check_state_change(state)
	
	# Handle WebSocket connection based on the current state
	match state:
		# When connected read all new messages.
		WebSocketPeer.STATE_OPEN:
			_read_new_packages()
		
		# Keep polling to achieve proper close.
		WebSocketPeer.STATE_CLOSING:
			return
		
		# Stop processing when connection is closed.
		WebSocketPeer.STATE_CLOSED:
			_connection_closed()
	pass

func connect_to_signaling_server():
	started_connection = true
	print("Trying to connect to SignalingServer on URL: ws://%s:%d." % [SERVER_IP, SERVER_PORT])
	var err = socket.connect_to_url("ws://%s:%d" % [SERVER_IP, SERVER_PORT])
	if err: print("Error connecting to SignalingServer: %s." % [err])
	pass

func _check_state_change(state):
	# Check if the State changed and initial connection happened
	if last_state == WebSocketPeer.STATE_CLOSED && state == WebSocketPeer.STATE_OPEN: 
		connected_to_server.emit()
		last_state = state
	pass

func _read_new_packages():
	while socket.get_available_packet_count():
		var payload_string = socket.get_packet().get_string_from_utf8()
		WebSocketMessage.handle_message(payload_string)
	pass

func _connection_closed():
	var code = socket.get_close_code()
	var reason = socket.get_close_reason()
	print("WebSocket closed with code: %d, reason %s. Clean: %s." % [code, reason, code != -1])
	connection_closed.emit()
	set_process(false) 
	pass

func _on_connected_to_server():
	print("Connected to SignalingServer on URL: ws://%s:%d." % [SERVER_IP, SERVER_PORT])
	WebSocketMessage.msg_open_lobby()
	pass
