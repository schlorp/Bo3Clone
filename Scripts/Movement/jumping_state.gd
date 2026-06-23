extends State
class_name JumpingState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JumpingState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.is_sprinting && state_machine.movement_node.is_grounded() && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return state_machine.movement_node.is_crouching() && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_moving() && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && state_machine.movement_node.is_grounded()
		)
	)
