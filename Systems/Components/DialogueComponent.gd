extends Node3D

@export var dialogue: DialogicTimeline = DialogicTimeline.new()

var can_interact : bool = false

@onready var interact_label = $Label3D
@onready var interact_screen = $InteractScreen

func _input(event) -> void:
	#This prevents the user from spamming the timeline and never being able to progress
	if Dialogic.current_timeline != null:
			return
			
	#Checks if the character is in range to interact
	if event.is_action_pressed("Interact") and can_interact: 
		interact_label.visible = false
		Dialogic.start(dialogue)

func _on_interact_area_body_entered(body) -> void:
	#Checks if the body is the player to avoid unwanted interactions between NPCs
	if body is Player:
		#This parses the input text to make the keybinding string look pretty in the menu
		var input_text = InputMap.action_get_events("Interact")[0].as_text()
		input_text = input_text.replace(" (Physical)", "")
		interact_label.text = str("Press ", input_text, " to interact")
		print("Can interact")
		
		#Show the interact prompts when nearby
		interact_label.visible = true
		interact_screen.visible = true
		input_text = null
		can_interact = true

func _on_interact_area_body_exited(body) -> void:
	#Again only applies if the body is a player
	if body is Player:
		#Hide the interact prompts when getting out of range from the NPC
		print("Can no longer interact")
		interact_label.visible = false
		interact_screen.visible = false
		can_interact = false
