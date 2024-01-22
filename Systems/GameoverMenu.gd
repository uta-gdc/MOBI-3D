extends Node

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/Level Zero - StartMenu.tscn")

func _on_quit_game_pressed() -> void:
	get_tree().quit()
