extends State
class_name FallingState

var can_jetpack: bool = false

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "FallingState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JetpackState"],
			func():	return !state_machine.movement_node.is_grounded() && Input.is_action_pressed("game_jump") && can_jetpack && state_machine.movement_node.jetpack_fuel > 0
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.is_grounded() && state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return state_machine.movement_node.is_grounded() && state_machine.movement_node.crouch_input
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return state_machine.movement_node.is_grounded() && state_machine.movement_node.is_moving()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return state_machine.movement_node.is_grounded() && !state_machine.movement_node.is_moving()
		)
	)

func update_state(delta: float) -> void:
	if Input.is_action_just_released("game_jump"):
		can_jetpack = true


func exit_state() -> void:
	if state_machine.movement_node.is_grounded():
		can_jetpack = false