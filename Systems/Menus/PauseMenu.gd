extends Node

#Remember to assign the level node in the Inspector window on the right side for this to not crash
@export var level : Node3D

@onready var player = $"../Level/Player"

func _input(event) -> void:
	if event.is_action_pressed("PauseMenu"):
		var isPaused : bool = get_tree().paused
		self.visible = !isPaused
		get_tree().paused = !isPaused
		level.visible = isPaused
		print("Im being paused")

func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Levels/Level Zero - StartMenu.tscn")

func _on_unstuck_button_pressed():
	#This was created as collisions between Player and 
	#anything else can occassionally lead to you being stuck. This allows the user to solve this.
	if player != null:
		player.global_transform.origin = Vector3(0, 0, 0)
		self.visible = false
		get_tree().paused = false
		level.visible = true
		return
	print("Player is dead cannot respawn")
