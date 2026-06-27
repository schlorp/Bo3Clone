class_name State

# Inherit from this class to create specific states
# (Extend this class to make concrete states like IdleState, RunState, etc.)

# Public getter for transitions (read-only)
var transitions: Array[Transition]:
    get:
        return _transitions

# Private list of transitions
var _transitions: Array[Transition] = []

# Name of the state
var state_name: String:
    get:
        return state_name
    set(value):
        state_name = value

var state_machine: StateMachine


# Constructor:
# When overwriting _init, make sure to call super._init()
# so this base logic is still executed
func _init(_statemachine: StateMachine) -> void:
    # Always set a default name for the state
    # Remove null and set your own state name
    state_name = "" # "BaseState"

    state_machine = _statemachine


# Called when the state is entered
func enter_state() -> void:
    pass


# Called every frame (or tick) while this state is active
func update_state(delta: float) -> void:
    pass


# Called when exiting the state
func exit_state() -> void:
    pass

func setup_transitions() -> void:
    # Override this function to add transitions to the state
    pass

# Add a transition to this state
func add_transition(transition: Transition) -> void:
    _transitions.append(transition)

func can_leave_state() -> bool:
    # Override this function to add custom logic for leaving the state
    return true
