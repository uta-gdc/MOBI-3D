extends Node3D
class_name HealthComponent

signal health_depleted

const MAX_HEALTH : int = 3

@export var health : int = 3

func damaged(attack_damage : int) -> void:
	health -= attack_damage
	if (health - attack_damage) <= 0:
		print("I died bruh")
