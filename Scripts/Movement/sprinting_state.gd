extends State
class_name SprintingState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "SprintingState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SlideState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded() && state_machine.movement_node.crouch_input
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
			state_machine.available_states["WalkingState"],
			func():	return !state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving() && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.sprint_input
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.sprint_speed