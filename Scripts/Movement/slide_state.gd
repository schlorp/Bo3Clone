extends State
class_name SlideState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "SlideState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return true #later will be when crouch is completed
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)
