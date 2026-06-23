extends State
class_name IdleState


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "IdleState"

	add_transition(
		Transition.new(
			self,
			_statemachine.available_states["WalkingState"],
			Callable(self, "is_moving")
		)
	)

func is_moving() -> bool:
	return _statemachine.movement_node._movement_vector.x != 0 or _statemachine.movement_node._movement_vector.z != 0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass
