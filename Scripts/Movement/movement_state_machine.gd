extends StateMachine
class_name MovementStateMachine

@export var movement_node: MovementNode

signal on_state_changed(state: State)

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


func switch_to_state(state_name: String) -> void:
	super.switch_to_state(state_name)
	emit_signal("on_state_changed", current_state)


func _ready() -> void:
	super._ready()
	switch_to_state("IdleState")


func _process(delta: float) -> void:
	super._process(delta)