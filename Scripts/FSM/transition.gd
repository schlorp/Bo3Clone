class_name Transition

var _from_state: State
var _to_state: State
var transition_condition: Callable

var from_state: State:
    get:
        return _from_state
    set(value):
        _from_state = value

var to_state: State:
    get:
        return _to_state
    set(value):
        _to_state = value

func _init(from_state: State, to_state: State, transition_condition: Callable) -> void:
    _from_state = from_state
    _to_state = to_state
    self.transition_condition = transition_condition
