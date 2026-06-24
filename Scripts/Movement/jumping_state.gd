extends State
class_name JumpingState

@export var jump_force: float = 2.5


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JumpingState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded() && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return state_machine.movement_node.crouch_input && state_machine.movement_node.is_grounded()
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

func enter_state() -> void:
	state_machine.movement_node.jump_basis = state_machine.movement_node.parent_character.transform.basis
	state_machine.movement_node.movement_vector.y = jump_force
