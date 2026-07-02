extends State
class_name FiringGunState

var fire_done: bool = false

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "FiringState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CyclingState"],
			func():	return fire_done
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["EmptyState"],
			func():	return fire_done && state_machine.gun.current_ammo <= 0
		)
	)