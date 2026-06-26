extends State
class_name SlideState

@export var slide_start_speed: float = 950.0
@export var slide_deceleration: float = 150.0
@export var slide_min_speed: float = 800.0

var slide_completed: bool = false

func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "SlideState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return slide_completed && state_machine.movement_node.is_moving() && state_machine.movement_node.sprint_input
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func():	return slide_completed
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)


# on enter state, set speed to start speed, let it slide a bit then decelerate in update to minimal speed, when it reaches minimal speed, transition to crouch state

func enter_state() -> void:
	slide_completed = false
	state_machine.movement_node.is_sliding = true
	state_machine.movement_node.current_movement_speed = slide_start_speed
	state_machine.movement_node.sliding_basis = state_machine.movement_node.parent_character.transform.basis

func update_state(delta: float) -> void:
	if state_machine.movement_node.current_movement_speed > slide_min_speed:
		state_machine.movement_node.current_movement_speed -= slide_deceleration * delta
	else:
		slide_completed = true


func exit_state() -> void:
	state_machine.start_slide_cooldown()
	state_machine.movement_node.is_sliding = false
