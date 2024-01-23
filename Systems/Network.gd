extends Node

#MULTIPLAYER ATTEMPTED DOES NOT WORK AS OF JANUARY 23, 2024

const PORT : int = 6007

@export var max_players : int = 4

var peer : ENetMultiplayerPeer
var address : String = "127.0.0.1"

var player_order : int = 1
@export var player_scene : PackedScene

func _ready():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	
func peer_connected(id):
	print("Player connected: " + str(id))

func peer_disconnected(id):
	print("Player disconnected: " + str(id))

func connected_to_server():
	print("Connected to server!")

func connection_failed():
	print("Couldn't connect to server.")

func server_disconnected():
	multiplayer.multiplayer_peer = null

@rpc("any_peer", "call_local")
func start_game():
	var scene = load("res://Scenes/Levels/Level One.tscn").instantiate()
	get_tree().root.add_child(scene)
	$".".hide()
	
func _on_host_pressed():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, max_players)
	if error != OK:
		print("Cannot host: " + error)
		return
		
	multiplayer.set_multiplayer_peer(peer)
	print("Waiting for players...")
	
func _on_join_pressed():
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, PORT)
	multiplayer.set_multiplayer_peer(peer)

func _on_start_pressed():
	start_game.rpc()
  
func _on_main_menu_pressed():
	multiplayer.multiplayer_peer = null
	get_tree().change_scene_to_file("res://Scenes/Levels/Level Zero - StartMenu.tscn")
