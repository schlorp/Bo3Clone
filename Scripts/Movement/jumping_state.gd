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
			state_machine.available_states["FallingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)


func enter_state() -> void:
	state_machine.movement_node.jump_basis = state_machine.movement_node.parent_character.transform.basis
	state_machine.movement_node.movement_vector.y = jump_force