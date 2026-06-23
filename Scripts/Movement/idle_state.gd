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
			func(): return state_machine.movement_node.is_moving() && !state_machine.is_sprinting && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func(): return !state_machine.movement_node.is_grounded() 
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func(): return state_machine.movement_node.is_crouching() && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.is_sprinting && state_machine.movement_node.is_grounded()
		)
	)
