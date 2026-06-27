extends State
class_name JumpingState

var jump_force: float


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JumpingState"

	jump_force = state_machine.movement_node.movement_resource.jump_force


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
	state_machine.movement_node.is_jumping = true
