extends State
class_name IdleState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"


func is_moving() -> bool:
	return state_machine.movement_node.movement_vector.x != 0 or state_machine.movement_node.movement_vector.z != 0


func is_jumping() -> bool:
	return state_machine.movement_node._player_ground_state == Enums.PlayerGroundState.IN_AIR


func is_crouching() -> bool:
	return state_machine.movement_node.current_movement_speed == state_machine.movement_node.crouch_speed


func is_sprinting() -> bool:
	return state_machine.movement_node.current_movement_speed == state_machine.movement_node.sprint_speed

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["WalkingState"],
			Callable(self, "is_moving")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["JumpingState"],
			Callable(self, "is_jumping")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["CrouchState"],
			Callable(self, "is_crouching")
		)
	)
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["SprintingState"],
			Callable(self, "is_sprinting")
		)
	)
