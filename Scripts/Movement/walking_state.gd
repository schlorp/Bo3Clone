extends State
class_name WalkingState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "WalkingState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return state_machine.movement_node.is_crouching()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.is_sprinting && state_machine.movement_node.is_grounded()
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