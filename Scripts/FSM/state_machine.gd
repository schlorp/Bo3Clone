extends Node
class_name StateMachine

# Inherit from this class to create specific state machines

# Current active state
var current_state: State:
	get:
		return _current_state
	set(value):
		_current_state = value

# All available states by name
var available_states: Dictionary:
	get:
		return _available_states
	set(value):
		_available_states = value


# Protected variables
var _current_state: State = null
var _available_states: Dictionary = {}


# Signal is the Godot equivalent of C# Action<State>
signal state_changed(new_state: State)


func _ready() -> void:
	# Called when the node enters the scene tree
	fill_available_states()


# Override this to add states and transitions
func fill_available_states() -> void:
	# !!Example of adding states to the dictionary!!
	# var new_state = StatePrefixState.new()
	# _available_states[new_state.state_name] = new_state

	# !!Example of adding transitions between states!!
	# phase_intro.add_transition(
	#     Transition.new(
	#         from_state,
	#         to_state, # State you want to transition to
	#         func(): return condition_to_switch_state
	#     )
	# )

	# or add a bool function in the state itself that checks for conditions
	# phase_intro.add_transition(
	#     Transition.new(
	#         phase_intro,
	#         phase_one,
	#         Callable(phase_intro, "is_intro_complete")
	#     )
	# )
	pass


func _process(delta: float) -> void:
	if _current_state == null:
		return

	update_current_state(delta)
	check_for_conditions_to_switch_state()


func update_current_state(delta: float) -> void:
	_current_state.update_state(delta)


func switch_to_state(state_name: String) -> void:
	if _available_states.has(state_name):
		if _current_state != null:
			_current_state.exit_state()

		set_state_to_current_state(state_name)


func set_state_to_current_state(state_name: String) -> void:
	_current_state = _available_states[state_name]
	_current_state.enter_state()

	emit_signal("state_changed", _current_state)


# Checks transitions of the current state
func check_for_conditions_to_switch_state() -> void:
	if _current_state == null:
		return

	for transition in _current_state.transitions:
		if transition.transition_condition.call():
			switch_to_state(transition.to_state.state_name)
			return
