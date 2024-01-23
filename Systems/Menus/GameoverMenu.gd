extends Node

var main_menu : String = "res://Scenes/Levels/Level Zero - StartMenu.tscn"

#All of this code is fairly self explanatory, but button signals doing scene changes

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file(main_menu)

func _on_quit_game_pressed() -> void:
	get_tree().quit()
