extends State
class_name WalkingState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "WalkingState"

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			Callable(state_machine, "is_not_moving")
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