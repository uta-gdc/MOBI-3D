extends CharacterBody3D

@export var attack_damage : int = 1
@export var target : Player

var speed : int = 5

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/StateMachine/playback")

func _on_hitbox_component_area_entered(area : Area3D):
	if area is HitboxComponent:
		area.damage(attack_damage)

func _process(delta: float):
	#print(player.position.distance_to(position))
	if target != null:
		if target.position.distance_to(position) < 1000:
			self.position = position.move_toward(target.position, delta * speed)

## Sets the model to a neutral, action-free state.
func idle():
	_state_machine.travel("Idle")
	
## Sets the model to a running animation or forward movement.
func run():
	_state_machine.travel("Run")

## Sets the model to an upward-leaping animation, simulating a jump.
func jump():
	_state_machine.travel("Jump")

## Sets the model to a downward animation, imitating a fall.
func fall():
	_state_machine.travel("Fall")

func update_animation():
	if velocity == Vector3.ZERO:
		idle()
	else:
		run()
	if velocity.y > 0:
		jump()
	elif velocity.y < 0:
		fall()
