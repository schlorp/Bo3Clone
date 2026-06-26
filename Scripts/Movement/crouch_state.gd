extends State
class_name CrouchState

var animation_player: AnimationPlayer = null
var collision_shape: CollisionShape3D = null
var capsule_shape: CapsuleShape3D = null

var shape_cast: ShapeCast3D = null

var crouch_height: float = 1.0
var crouch_radius: float = 0.25

var stand_height: float = 2.0
var stand_radius: float = 0.5

var can_un_crouch: bool = true

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CrouchState"
	
	animation_player = state_machine.animation_player
	collision_shape = state_machine.collision_shape
	capsule_shape = collision_shape.shape as CapsuleShape3D

	shape_cast = state_machine.crouch_shape_cast


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
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving() && can_un_crouch
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input && can_un_crouch || Input.is_action_just_pressed("game_jump") && can_un_crouch
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input && can_un_crouch
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.crouch_speed
	animation_player.play("Crouch", -1.0 ,1.0)

	await animation_player.animation_finished

	capsule_shape.height = crouch_height
	capsule_shape.radius = crouch_radius
	collision_shape.position.y = (crouch_height - stand_height) / 2.0

func update_state(delta: float) -> void:
	can_un_crouch = !state_machine.movement_node.crouch_input && !shape_cast.is_colliding()

func exit_state() -> void:
	animation_player.play("Crouch", -1.0 ,-1.0, true)
	
	await animation_player.animation_finished
	
	capsule_shape.height = stand_height
	capsule_shape.radius = stand_radius
	collision_shape.position.y = 0
