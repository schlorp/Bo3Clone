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

func enter_state() -> void:
	fire_done = false

	await state_machine.gun.fire()

	fire_done = true
