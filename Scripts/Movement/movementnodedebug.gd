extends RichTextLabel

@onready var movement_state_machine: MovementStateMachine = get_parent() as MovementStateMachine

var ground_state_text: String = "ground state = "
var movement_state_text: String = "movement state = "

func _ready() -> void:
	movement_state_machine.movement_node.connect("ground_state_changed", Callable(self, "on_ground_state_changed"))
	movement_state_machine.connect("on_state_changed", Callable(self, "on_movement_state_changed"))


func _process(delta: float) -> void:
	process_text()


func on_ground_state_changed(state: Enums.PlayerGroundState) -> void:
	ground_state_text = "ground state = " + str(Enums.PlayerGroundState.keys()[state]) + "\n"


func on_movement_state_changed(state: State) -> void:
	movement_state_text = "movement state = " + state.state_name


func process_text() -> void:
	text = ground_state_text + "speed = " + str(movement_state_machine.movement_node.current_movement_speed) + "\n" + movement_state_text