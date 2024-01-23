extends Resource
class_name UserPreference

#ATTEMPTED TO SAVE KEYBINDS, DOES NOT WORK AS OF JANUARY 23, 2024
@export var keymaps: Dictionary = {}
	
func save_to_file(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(keymaps)
	file.close()
		
func load_from_file(path: String) -> void:
	if FileAccess.file_exists(path):
		var save_file = FileAccess.open(path, FileAccess.READ)
		keymaps = save_file.get_var()
		save_file.close()
		apply_keymaps()
		
func apply_keymaps() -> void:
	for action in keymaps.keys():
		InputMap.action_erase_events(action)
		for event in keymaps[action]:
			InputMap.action_add_event(action, event)
