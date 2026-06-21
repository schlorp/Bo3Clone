extends Node
class_name MovementNode

@onready var parent_character: CharacterBody3D = get_parent() as CharacterBody3D
@export var input_parser: PlayerInputParseNode
@export var movement_speed: float = 5.0

var movement_vector: Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	input_parser.connect("on_movement_input", Callable(self, "handle_movement_input"))

func handle_movement_input(vector: Vector3) -> void:
	var direction := Vector3.ZERO
	direction.x = vector.x
	direction.z = vector.z
	direction = direction.normalized()
	movement_vector.x = direction.x
	movement_vector.z = direction.z

func move(delta: float) -> void:
	parent_character.velocity = parent_character.transform.basis * movement_vector * movement_speed * delta 
	parent_character.move_and_slide()

func apply_gravity(delta: float) -> void:
	if not parent_character.is_on_floor():
		movement_vector.y -= gravity * delta
	else:
		movement_vector.y = 0

func _physics_process(delta: float) -> void:
	move(delta)
	apply_gravity(delta)
	parent_character.move_and_slide()
