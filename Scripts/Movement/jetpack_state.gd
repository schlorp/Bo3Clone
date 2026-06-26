extends State
class_name JetpackState

var jetpack_force: float = 50

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JetpackState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FallingState"],
			func():	return Input.is_action_just_released("game_jump")
		)
	)


func update_state(delta: float) -> void:
	state_machine.movement_node.movement_vector.y = jetpack_force * delta
