extends Control

@onready var main_scene = "res://Scenes/Levels/Level One.tscn"

func _on_start_game_pressed() -> void:
	start_game()

#Abstraction functions
func showPanel(panel) -> void:
	panel.visible = true
	$MainButtons.visible = false
	
func exitPanel(panel) -> void:
	panel.visible = false
	$MainButtons.visible = true
#

func _on_settings_pressed() -> void:
	showPanel($SettingsPanel)

func _on_credits_pressed() -> void:
	showPanel($CreditsPanel)

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_exit_pressed() -> void:
	exitPanel($SettingsPanel)

func _on_credits_exit_pressed() -> void:
	exitPanel($CreditsPanel)

func start_game() -> void:
	get_tree().change_scene_to_file(main_scene)

func _on_multiplayer_pressed():
	get_tree().change_scene_to_file("res://Scenes/Menus/MultiplayerMenu.tscn")
