extends State
class_name IdleState

var animation_player: AnimationPlayer = null


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"

	animation_player = state_machine.animation_player


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
			state_machine.available_states["WalkingState"],
			func(): return state_machine.movement_node.is_moving() && !state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			func(): return state_machine.movement_node.is_grounded() && Input.is_action_just_pressed("game_jump")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			func(): return state_machine.movement_node.crouch_input && state_machine.movement_node.is_grounded()
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			func():	return state_machine.movement_node.sprint_input && state_machine.movement_node.is_grounded()
		)
	)

func enter_state() -> void:
	if animation_player.current_animation != "Walking":
		await animation_player.animation_finished
		animation_player.play("Idle")
	else:
		animation_player.pause()
