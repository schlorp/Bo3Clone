extends State
class_name SlideState

var slide_start_speed: float
var slide_deceleration: float
var slide_min_speed: float

var _slide_completed: bool = false
var _animation_started: bool = false
var _animation_finished: bool = false

var _shape_cast: ShapeCast3D = null
var _animation_player: AnimationPlayer = null
var _collision_shape: CollisionShape3D = null
var _capsule_shape: CapsuleShape3D = null

var _slide_height: float
var _slide_radius: float

var _stand_height: float
var _stand_radius: float

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "SlideState"

	_shape_cast = state_machine.head_hitter_shape_cast
	_animation_player = state_machine.animation_player

	_collision_shape = state_machine.collision_shape
	_capsule_shape = _collision_shape.shape as CapsuleShape3D

	slide_start_speed = state_machine.movement_node.movement_resource.slide_start_speed
	slide_deceleration = state_machine.movement_node.movement_resource.slide_deceleration
	slide_min_speed = state_machine.movement_node.movement_resource.slide_min_speed
	
	_slide_height = state_machine.movement_node.movement_resource.slide_height
	_slide_radius = state_machine.movement_node.movement_resource.slide_radius
	_stand_height = state_machine.movement_node.movement_resource.stand_height
	_stand_radius = state_machine.movement_node.movement_resource.stand_radius

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return _slide_completed && state_machine.movement_node.is_moving() && state_machine.movement_node.sprint_input && can_leave_state()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return Input.is_action_just_pressed("game_jump") && can_leave_state()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return _slide_completed
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FallingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)


# on enter state, set speed to start speed, let it slide a bit then decelerate in update to minimal speed, when it reaches minimal speed, transition to crouch state

func enter_state() -> void:
	_slide_completed = false
	_animation_started = false
	_animation_finished = false
	
	state_machine.movement_node.is_sliding = true
	state_machine.movement_node.current_movement_speed = slide_start_speed
	state_machine.movement_node.sliding_basis = state_machine.movement_node.parent_character.transform.basis

	_animation_player.play("Slide", -1.0 ,1.0)

	_capsule_shape.height = _slide_height
	_capsule_shape.radius = _slide_radius
	_collision_shape.position.y = (_slide_height - _stand_height) / 2.0

func update_state(delta: float) -> void:
	if state_machine.movement_node.current_movement_speed > slide_min_speed:
		state_machine.movement_node.current_movement_speed -= slide_deceleration * delta
	else:
		_slide_completed = true

	if _slide_completed && !_animation_started:
		unslide()

func unslide() -> void:
	_animation_started = true
	_animation_player.play("Slide", 1.0 ,-1.0, true)

	_animation_finished = false

	await _animation_player.animation_finished

	_capsule_shape.height = _stand_height
	_capsule_shape.radius = _stand_radius
	_collision_shape.position.y = 0

	_animation_finished = true

func exit_state() -> void:
	state_machine.start_slide_cooldown()
	state_machine.movement_node.is_sliding = false


func can_leave_state() -> bool:
	return !_shape_cast.is_colliding()
