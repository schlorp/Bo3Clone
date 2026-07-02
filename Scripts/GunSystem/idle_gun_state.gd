extends State
class_name IdleGunState

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FiringState"],
			func():	return Input.is_action_just_pressed("game_fire")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["ReloadState"],
			func():	return Input.is_action_just_pressed("game_reload_gun")
		)
	)