extends CharacterBody3D
class_name Player

## Emitted when Gobot's feet hit the ground will running.
signal foot_step
## Gobot's MeshInstance3D model.
@export var gobot_model: MeshInstance3D
## Determines whether blinking is enabled or disabled.
@export var blink = true : set = _set_blink
@export var _left_eye_mat_override: String
@export var _right_eye_mat_override: String
@export var _open_eye: CompressedTexture2D
@export var _close_eye: CompressedTexture2D

@export var mouse_sensitivity : float = 0.001
#@export var color_hexcode : String

var direction : Vector3 = Vector3.ZERO

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

var jump_height : int = 10
var max_speed : int = 5
var speed : int = max_speed
var accel : int = 5
var dash_speed : int = speed * 50
var max_jump_count : int = 3
var jump_counter : int = 0

var is_jumping : bool = false
var can_move : bool = true
var can_dash : bool = true

var is_emoting : bool = false

@onready var _animation_tree: AnimationTree = %AnimationTree
@onready var _state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get(
		"parameters/StateMachine/playback"
)

@onready var _flip_shot_path: String = "parameters/FlipShot/request"
@onready var _hurt_shot_path: String = "parameters/HurtShot/request"

@onready var spring_arm = $SpringArm3D

@onready var dash_timer : Timer = $DashTimer
@onready var _blink_timer : Timer = %BlinkTimer
@onready var _closed_eyes_timer : Timer = %ClosedEyesTimer

@onready var _left_eye_mat: StandardMaterial3D = gobot_model.get(_left_eye_mat_override)
@onready var _right_eye_mat: StandardMaterial3D = gobot_model.get(_right_eye_mat_override)

@onready var footsteps_sound : AudioStreamPlayer3D = $Footsteps
@onready var jump_sound : AudioStreamPlayer3D = $Jump
@onready var roll_sound : AudioStreamPlayer3D  = $Roll


func _ready():
	_blink_timer.connect(
			"timeout",
			func():
				_left_eye_mat.albedo_texture = _close_eye
				_right_eye_mat.albedo_texture = _close_eye
				_closed_eyes_timer.start(0.2)
	)

	_closed_eyes_timer.connect(
			"timeout",
			func():
				_left_eye_mat.albedo_texture = _open_eye
				_right_eye_mat.albedo_texture = _open_eye
				_blink_timer.start(randf_range(1.0, 8.0))
	)
	
	Dialogic.signal_event.connect(dialogic_signal)

func _process(_delta):
	print(str("The velocity is ", velocity))
	if Input.is_action_just_pressed("Emote1") and !is_jumping:
		is_emoting = true
		speed = 0
		victory_sign()
	elif Input.is_action_just_pressed("Emote2") and !is_jumping:
		is_emoting = true
		speed = 0
		edge_grab()
	elif Input.is_action_just_pressed("Emote3") and !is_jumping:
		is_emoting = true
		speed = 0
		wall_slide()
	elif not is_emoting:
		speed = max_speed
		update_animation()
	
func _physics_process(delta):
	velocity.y += -gravity * delta
	
	if can_move:
		var input_x = Input.get_action_strength("MoveLeft") - Input.get_action_strength("MoveRight")
		var input_z = Input.get_action_strength("MoveForward") - Input.get_action_strength("MoveBackward")

		var movement_direction = Vector3(input_x, 0, input_z).normalized()
		
		if movement_direction != Vector3.ZERO:
			velocity.x = movement_direction.x * speed
			velocity.z = movement_direction.z * speed
			
			var target_rotation = Vector3(0, atan2(movement_direction.x, movement_direction.z), 0)
			gobot_model.rotation.y = lerp_angle(gobot_model.rotation.y, target_rotation.y, 15 * delta)
			
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.z = move_toward(velocity.z, 0, speed)
		
		if Input.is_action_just_pressed("Jump"):
			if jump_counter < max_jump_count:
				jump_counter += 1
				jump_sound.play()
				velocity.y = 0
				velocity.y += jump_height
				jump()
				is_jumping = true
				
		if Input.is_action_just_pressed("Dash"):
			if can_dash:
				roll_sound.play()
				velocity += movement_direction * dash_speed
				flip()
				can_dash = false
				dash_timer.start()
		lerp(velocity, velocity, delta)
		move_and_slide()
	
	if is_on_floor():
		jump_counter = 0
		is_jumping = false
		if can_move:
			if velocity != Vector3.ZERO:
				if not footsteps_sound.playing:
					footsteps_sound.play()
			else:
				if footsteps_sound.playing:
					footsteps_sound.stop()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		spring_arm.rotation.x += event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -15, 15)
		
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
		spring_arm.rotation_degrees.y = clamp(spring_arm.rotation_degrees.y, -30, 30)
		
func _set_blink(state: bool):
	if blink == state:
		return
	blink = state
	if blink:
		_blink_timer.start(0.2)
	#else:
		#_blink_timer.stop()
		#_closed_eyes_timer.stop()

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

## Sets the model to an edge-grabbing animation.
func edge_grab():
	_state_machine.travel("EdgeGrab")

## Sets the model to a wall-sliding animation.
func wall_slide():
	_state_machine.travel("WallSlide")

## Plays a one-shot front-flip animation.
## This animation does not play in parallel with other states.
func flip():
	_animation_tree.set(_flip_shot_path, true)

## Makes a victory sign.
func victory_sign():
	_state_machine.travel("VictorySign")

## Plays a one-shot hurt animation.
## This animation plays in parallel with other states.
func hurt():
	_animation_tree.set(_hurt_shot_path, true)
	var tween := create_tween().set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector3(1.2, 0.8, 1.2), 0.1)
	tween.tween_property(self, "scale", Vector3.ONE, 0.2)

func update_animation():
	if velocity == Vector3.ZERO or !can_move:
		idle()
	else:
		run()
		
	if velocity.y > 0 and can_move:
		jump()
	elif velocity.y < 0 and can_move:
		fall()

func _on_dash_timer_timeout():
	can_dash = true
	
func _on_animation_tree_animation_finished(_anim_name):
	is_emoting = false

func dialogic_signal(argument) -> void:
	if argument == 'dialogue_start':
		can_move = false
	elif argument == 'dialogue_end':
		can_move = true
		
