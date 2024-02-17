extends Node3D

@onready var pause_menu = $"../PauseMenu"
@onready var gameover_menu = $"../GameoverMenu"
@onready var mobile_controls = $"../MobileControls"

func _ready() -> void:
	var player = get_node_or_null("Player")
	if player:
		var health_component = player.get_node_or_null("HealthComponent")
		if health_component:
			health_component.connect("health_depleted", Callable(self, "open_gameover"))
		else:
			print("HealthComponent not found")
	else:
		print("Player not found")
	
func open_gameover() -> void:
	print("Gameover")
	$"../GameoverSound".play()
	gameover_menu.visible = true
	pause_menu.visible = false
	mobile_controls.visible = false
	
