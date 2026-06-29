extends State
class_name SprintingState

var animation_player: AnimationPlayer = null

var animation_speed: float
var sprint_speed: float


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "SprintingState"

	animation_player = state_machine.animation_player
	
	animation_speed = state_machine.movement_node.movement_resource.sprint_animation_speed
	sprint_speed = state_machine.movement_node.movement_resource.sprint_speed

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FallingState"],
			func():	return !state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SlideState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded() && state_machine.movement_node.crouch_input && state_machine.can_slide
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func():	return state_machine.movement_node.is_grounded() && Input.is_action_just_pressed("game_jump")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			func():	return !state_machine.movement_node.sprint_input && state_machine.movement_node.is_moving() && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return !state_machine.movement_node.is_moving() && !state_machine.movement_node.sprint_input
		)
	)

func enter_state() -> void:
	state_machine.movement_node.current_movement_speed = sprint_speed
	animation_player.play("Walking")
	animation_player.speed_scale = animation_speed
