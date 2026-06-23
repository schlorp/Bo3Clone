extends State
class_name IdleState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			Callable(state_machine, "is_moving")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			Callable(state_machine, "is_jumping")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			Callable(state_machine, "is_crouching")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			Callable(state_machine, "is_sprinting")
		)
	)
