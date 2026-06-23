extends StateMachine


@export var movement_node: MovementNode


func fill_available_states() -> void:
	var idle_state = IdleState.new(self)
	var walking_state = WalkingState.new(self)
	var sprinting_state = SprintingState.new(self)
	var jumping_state = JumpingState.new(self)
	var crouch_state = CrouchState.new(self)
	var slide_state = SlideState.new(self)

	_available_states = {
		idle_state.state_name: idle_state,
		walking_state.state_name: walking_state,
		sprinting_state.state_name: sprinting_state,
		jumping_state.state_name: jumping_state,
		crouch_state.state_name: crouch_state,
		slide_state.state_name: slide_state
	}

	for state in _available_states.values():
		state.setup_transitions()


func _ready() -> void:
	super._ready()
	switch_to_state("IdleState")


func _process(delta: float) -> void:
	super._process(delta)
	print("Current State: ", _current_state.state_name)


func is_sprinting() -> bool:
	return movement_node.current_movement_speed == movement_node.sprint_speed

func is_crouching() -> bool:
	return movement_node.current_movement_speed == movement_node.crouch_speed

func is_jumping() -> bool:
	return movement_node._player_ground_state == Enums.PlayerGroundState.IN_AIR

func is_moving() -> bool:
	return movement_node.movement_vector.x != 0 or movement_node.movement_vector.z != 0

func is_not_moving() -> bool:
	return movement_node.movement_vector.x == 0 and movement_node.movement_vector.z == 0