extends Node3D

@export var dialogue: DialogicTimeline = DialogicTimeline.new()

var can_interact : bool = false

@onready var interact_label = $Label3D
@onready var interact_screen = $InteractScreen

func _input(event) -> void:
	if Dialogic.current_timeline != null:
			return
	if event.is_action_pressed("Interact") and can_interact:
		interact_label.visible = false
		Dialogic.start(dialogue)

func _on_interact_area_body_entered(body) -> void:
	if body is Player:
		var input_text = InputMap.action_get_events("Interact")[0].as_text()
		input_text = input_text.replace(" (Physical)", "")
		interact_label.text = str("Press ", input_text, " to interact")
		print("Can interact")
		interact_label.visible = true
		interact_screen.visible = true
		input_text = null
		can_interact = true

func _on_interact_area_body_exited(body) -> void:
	if body is Player:
		print("Can no longer interact")
		interact_label.visible = false
		interact_screen.visible = false
		can_interact = false
