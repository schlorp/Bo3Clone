extends HSlider

@onready var movement_node: Node = get_parent() as MovementNode

func _ready() -> void:
	value = movement_node.jetpack_fuel

func _process(delta: float) -> void:
	value = movement_node.jetpack_fuel
	
	if value == 100:
		visible = false
	else:
		visible = true