extends State
class_name CrouchState

var animation_player: AnimationPlayer = null
var collision_shape: CollisionShape3D = null
var capsule_shape: CapsuleShape3D = null

var shape_cast: ShapeCast3D = null

var crouch_speed: float

var crouch_height: float
var crouch_radius: float

var stand_height: float
var stand_radius: float

var can_un_crouch: bool = true
var animation_finished: bool = false

var uncrouch_animation_playing: bool = false

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CrouchState"
	
	animation_player = state_machine.animation_player
	collision_shape = state_machine.collision_shape
	capsule_shape = collision_shape.shape as CapsuleShape3D

	shape_cast = state_machine.head_hitter_shape_cast

	crouch_speed = state_machine.movement_node.movement_resource.crouch_speed

	crouch_height = state_machine.movement_node.movement_resource.crouch_height
	crouch_radius = state_machine.movement_node.movement_resource.crouch_radius

	stand_height = state_machine.movement_node.movement_resource.stand_height
	stand_radius = state_machine.movement_node.movement_resource.stand_radius


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FallingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving() && can_leave_state()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input && can_leave_state() || Input.is_action_just_pressed("game_jump") && can_leave_state()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input && can_leave_state()
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.movement_resource.crouch_speed
	animation_player.play("Crouch", 1.0 ,1.0)

	await animation_player.animation_finished

	capsule_shape.height = crouch_height
	capsule_shape.radius = crouch_radius
	collision_shape.position.y = (crouch_height - stand_height) / 2.0

func update_state(delta: float) -> void:
	can_un_crouch = !state_machine.movement_node.crouch_input && !shape_cast.is_colliding()

	if can_un_crouch && !uncrouch_animation_playing:
		play_uncrouch_animation()

	if uncrouch_animation_playing && state_machine.movement_node.crouch_input:
		uncrouch_animation_playing = false
		enter_state()


func play_uncrouch_animation() -> void:
	uncrouch_animation_playing = true
	animation_player.play("Crouch", -1.0 ,-1.0, true)

	animation_finished = false

	await animation_player.animation_finished
	
	capsule_shape.height = stand_height
	capsule_shape.radius = stand_radius
	collision_shape.position.y = 0

	animation_finished = true

func exit_state() -> void:
	uncrouch_animation_playing = false

func can_leave_state() -> bool:
	return can_un_crouch && animation_finished
