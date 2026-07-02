extends State
class_name CyclingGunState

var cycling_done: bool = false

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CyclingState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return cycling_done && state_machine.gun.current_ammo > 0
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["EmptyState"],
			func():	return cycling_done && state_machine.gun.current_ammo <= 0
		)
	)