extends CharacterBody3D

@export var attack_damage : int = 1
@export var target : Player

func _on_hitbox_component_area_entered(area):
	if area is HitboxComponent:
		area.damage(attack_damage)
