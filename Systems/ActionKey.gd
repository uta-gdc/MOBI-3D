extends Button

@export var action: String = "MoveForward"

#ATTEMPTED TO SAVE KEYBINDS DOES NOT WORK AS OF JANUARY 23, 2024
#var keybinds_resource: UserPreference = UserPreference.new()

func _init() -> void:
	toggle_mode = true
	
func _ready() -> void:
	var input_text = InputMap.action_get_events(action)[0].as_text()
	input_text = input_text.replace(" (Physical)", "")
	text = input_text
	set_process_unhandled_input(false)
	
func _toggled(toggled_on) -> void:
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "Press any key"

func _unhandled_input(event) -> void:
	if event is InputEventKey and event.pressed:
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		button_pressed = false
		release_focus()
		update_text()
		
		#keybinds_resource.keymaps[action] = InputMap.action_get_events(action)
		#keybinds_resource.apply_keymaps()
		#keybinds_resource.save_to_file("user://keymaps.dat")
		
		
func update_text() -> void:
	text = InputMap.action_get_events(action)[0].as_text()
