extends Area3D
class_name HitboxComponent

@export var health_component : HealthComponent

func damage(attack_damage = 1) -> void:
	if health_component:
		health_component.damaged(attack_damage)
