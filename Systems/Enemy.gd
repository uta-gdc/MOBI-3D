extends CharacterBody3D

@export var attack_damage : int = 1
@export var target : Player

var speed : int = 20

@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D

func _on_hitbox_component_area_entered(area : Area3D):
	if area is HitboxComponent:
		area.damage(attack_damage)

func _physics_process(delta: float):
	#print(player.position.distance_to(position))
	velocity = Vector3.ZERO
	
	if target != null:
		if target.position.distance_to(position) < 10:
			#self.position = position.move_toward(target.position, delta * speed)
			navigation_agent_3d.set_target_position(target.global_transform.origin)
			var next_nav_point = navigation_agent_3d.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * speed
			
			look_at(Vector3(target.global_position.x, global_position.y, target.global_position.z), Vector3.UP)
			
			move_and_slide()
