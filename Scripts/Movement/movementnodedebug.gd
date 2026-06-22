extends RichTextLabel

@onready var movement_node: MovementNode = get_parent() as MovementNode

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movement_node.connect("movement_state_changed", Callable(self, "on_movement_state_changed"))


func on_movement_state_changed(state: Enums.PlayerMovementState) -> void:
	text = "movement state = " + str(Enums.PlayerMovementState.keys()[state])