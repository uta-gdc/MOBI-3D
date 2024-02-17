extends Node3D
class_name HealthComponent

signal took_damage
signal health_depleted

@export var max_health : int = 3

@export var health : int = 3

@onready var health_bar : ProgressBar = $SubViewport/HealthBar

func _ready():
	health_bar.max_value = max_health
	health_bar.value = max_health
	
func damaged(attack_damage : int = 1) -> void:
	health -= attack_damage
	health_bar.value = health
	health_bar.show()
	emit_signal("took_damage")
	if health <= 0:
		print("I died bruh")
		emit_signal("health_depleted")
		get_parent().queue_free()
