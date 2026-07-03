extends State
class_name IdleGunState

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["EmptyState"],
			func():	return handle_transition_with_fire_mode() && state_machine.gun.current_ammo <= 0
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FiringState"],
			func():	return handle_transition_with_fire_mode() && state_machine.gun.current_ammo > 0
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["ReloadState"],
			func():	return Input.is_action_just_pressed("game_reload_gun")
		)
	)

func handle_transition_with_fire_mode() -> bool:
	var current_fire_mode = state_machine.gun.current_fire_mode

	if current_fire_mode == Enums.FireMode.AUTOMATIC:
		if Input.is_action_pressed("game_fire"):
			return true

	elif current_fire_mode == Enums.FireMode.SEMI_AUTOMATIC:
		if Input.is_action_just_pressed("game_fire"):
			return true

	elif current_fire_mode == Enums.FireMode.BURST:
		pass

	return false