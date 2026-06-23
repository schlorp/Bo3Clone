extends RichTextLabel

@onready var movement_node: MovementNode = get_parent() as MovementNode

var ground_state_text: String = "ground state = "
var movement_state_text: String = "movement state = "

func _ready() -> void:
	movement_node.connect("ground_state_changed", Callable(self, "on_ground_state_changed"))
	movement_node.connect("movement_state_changed", Callable(self, "on_movement_state_changed"))

func _process(delta: float) -> void:
	process_text()


func on_ground_state_changed(state: Enums.PlayerGroundState) -> void:
	ground_state_text = "ground state = " + str(Enums.PlayerGroundState.keys()[state]) + "\n"

func on_movement_state_changed(state: Enums.PlayerMovementState) -> void:
	movement_state_text = "movement state = " + str(Enums.PlayerMovementState.keys()[state])

func process_text() -> void:
	text = ground_state_text + "speed = " + str(movement_node.current_movement_speed) + "\n" + movement_state_text