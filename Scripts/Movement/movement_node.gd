extends Node
class_name MovementNode

@onready var parent_character: CharacterBody3D = get_parent() as CharacterBody3D
@export var input_parser: PlayerInputParseNode
@export var movement_speed: float = 5.0
@export var jump_force: float = 2.5

var jump_basis: Basis

var player_movement_state: Enums.PlayerMovementState = Enums.PlayerMovementState.ON_GROUND

var movement_vector: Vector3 = Vector3.ZERO
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal movement_state_changed(state: Enums.PlayerMovementState)

func _ready() -> void:
	input_parser.connect("on_movement_input", Callable(self, "handle_movement_input"))
	input_parser.connect("on_jump_input_just_pressed", Callable(self, "jump"))


func handle_movement_input(vector: Vector3) -> void:
	if player_movement_state == Enums.PlayerMovementState.IN_AIR:
		return

	var direction := Vector3.ZERO
	direction.x = vector.x
	direction.z = vector.z
	direction = direction.normalized()
	movement_vector.x = direction.x
	movement_vector.z = direction.z


func apply_movementvector(delta: float) -> void:
	if player_movement_state == Enums.PlayerMovementState.IN_AIR:
		parent_character.velocity = jump_basis * movement_vector * movement_speed * delta 
	else: 
		parent_character.velocity = parent_character.transform.basis * movement_vector * movement_speed * delta 
	print("Movement Vector: ", movement_vector)
	print ("Transform Basis: ", parent_character.transform.basis)
	print("Velocity: ", parent_character.velocity)

	parent_character.move_and_slide()


func apply_gravity(delta: float) -> void:
	if !parent_character.is_on_floor():
		movement_vector.y -= gravity * delta
	else:
		movement_vector.y = 0


func _physics_process(delta: float) -> void:
	apply_movementvector(delta)
	apply_gravity(delta)
	update_movement_state()


func jump() -> void:
	if player_movement_state == Enums.PlayerMovementState.ON_GROUND:
		jump_basis = parent_character.transform.basis
		movement_vector.y = jump_force



func update_movement_state() -> void:
	if parent_character.is_on_floor():
		player_movement_state = Enums.PlayerMovementState.ON_GROUND
	else:
		player_movement_state = Enums.PlayerMovementState.IN_AIR

	emit_signal("movement_state_changed", player_movement_state)