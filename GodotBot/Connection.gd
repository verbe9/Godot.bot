extends Node

var websocket_url = "ws://127.0.0.1:8000/"
var messageTOSend = ""

@onready var _client : WebSocketClient = $WebSocketClient

signal sign_message(msg : String)

func  _connect_to_streamerbot():
	var error = _client.connect_to_url(websocket_url)
	if error != OK:
		print("Error connecting to : %s" % [websocket_url])
	

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Looking for Streamerbot server...")
	_connect_to_streamerbot()


func _on_websocket_client_close():
	var ws = _client.get_socket()
	print("Client disconnected with code: %s, reason %s" %[ws.get_close_code(),ws.get_close_reason()])
	
func _on_websocket_client_connected():
	print("Client connected to server...")
	_subscribe_to_event()
	
func _on_message_recieved(message):
	var parsed = JSON.parse_string(message)
	if parsed.has("data"):
		var event_data: Dictionary = parsed["data"]
		if event_data["event"]=="Chat_Message":
			sign_message.emit("%s : %s"%[event_data["user"],event_data["message"]])
			print("Got message from %s %s" % [event_data["user"],event_data["message"]])
		if event_data["event"]=="New_Follow":
			print("%s is now following" % event_data["user"])
	else:
		print("Got message: %s" % parsed)
	
func _subscribe_to_event():
		
		var data_to_send = {"request": "Subscribe","id": "godot","events": {"General": ["Custom"]}}
		_client.send(JSON.stringify(data_to_send))
		
		
	
