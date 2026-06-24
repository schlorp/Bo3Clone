extends State
class_name CrouchState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CrouchState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input || Input.is_action_just_pressed("game_jump")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.crouch_input
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = state_machine.movement_node.crouch_speed
