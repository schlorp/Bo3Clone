extends State
class_name CrouchState

var animation_player: AnimationPlayer = null
var collision_shape: CollisionShape3D = null
var capsule_shape: CapsuleShape3D = null

var crouch_height: float = 1.0
var crouch_radius: float = 0.25

var stand_height: float = 2.0
var stand_radius: float = 0.5

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CrouchState"
	
	animation_player = state_machine.animation_player
	collision_shape = state_machine.collision_shape
	capsule_shape = collision_shape.shape as CapsuleShape3D


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input || Input.is_action_just_pressed("game_jump")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.crouch_speed
	animation_player.play("Crouch", -1.0 ,1.0)

	await animation_player.animation_finished

	capsule_shape.height = crouch_height
	capsule_shape.radius = crouch_radius
	collision_shape.position.y = (crouch_height - stand_height) / 2.0

func exit_state() -> void:
	animation_player.play("Crouch", -1.0 ,-1.0, true)
	
	await animation_player.animation_finished
	
	capsule_shape.height = stand_height
	capsule_shape.radius = stand_radius
	collision_shape.position.y = 0
