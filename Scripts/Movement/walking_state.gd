extends State
class_name WalkingState


var animation_player: AnimationPlayer = null

var animation_speed: float = 1.0

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "WalkingState"

	animation_player = state_machine.animation_player

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
			state_machine.available_states["CrouchState"],
			func():	return state_machine.movement_node.crouch_input
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return state_machine.movement_node.is_grounded() && Input.is_action_just_pressed("game_jump")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving()
		)
	)


func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.walk_speed
	animation_player.play("Walking")
	animation_player.speed_scale = animation_speed
