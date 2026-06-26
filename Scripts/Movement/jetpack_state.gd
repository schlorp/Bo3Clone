extends State
class_name JetpackState

var jetpack_force: float = 2.5

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JetpackState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return Input.is_action_just_released("game_jump")
		)
	)

func enter_state() -> void:
	pass

func update_state(delta: float) -> void:
	state_machine.movement_node.movement_vector.y = jetpack_force
