extends Node
class_name MovementNode

@onready var parent_character: CharacterBody3D = get_parent() as CharacterBody3D
@export var input_parser: PlayerInputParseNode

@export var movement_resource: MovementResource

var jetpack_fuel: float = 100.0
var is_jetpack_active: bool = false

@onready var current_movement_speed: float = movement_resource.walk_speed

var jump_basis: Basis
var sliding_basis: Basis

var crouch_input: bool = false
var sprint_input: bool = false

var is_sliding: bool = false
var is_jumping: bool = false

var player_ground_state: Enums.PlayerGroundState = Enums.PlayerGroundState.ON_GROUND

var movement_vector: Vector3 = Vector3.ZERO
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal ground_state_changed(state: Enums.PlayerGroundState)

func _ready() -> void:
	input_parser.connect("on_movement_input", Callable(self, "handle_movement_input"))
	input_parser.connect("on_sprint_input", Callable(self, "sprint"))
	input_parser.connect("on_crouch_input", Callable(self, "crouch"))

func handle_movement_input(vector: Vector3) -> void:
	if is_jumping && !is_jetpack_active || is_sliding:
		return

	var direction := Vector3.ZERO
	direction.x = vector.x
	direction.z = vector.z
	direction = direction.normalized()
	movement_vector.x = direction.x
	movement_vector.z = direction.z


func apply_movementvector(delta: float) -> void:
	if is_jumping && !is_jetpack_active:
		parent_character.velocity = jump_basis * movement_vector * current_movement_speed * delta 
	elif is_sliding:
		parent_character.velocity = sliding_basis * movement_vector * current_movement_speed * delta
	else: 
		parent_character.velocity = parent_character.transform.basis * movement_vector * current_movement_speed * delta 

	parent_character.move_and_slide()


func apply_gravity(delta: float) -> void:
	if !parent_character.is_on_floor():
		movement_vector.y -= _gravity * delta
	else:
		movement_vector.y = 0


func _physics_process(delta: float) -> void:
	apply_movementvector(delta)
	apply_gravity(delta)
	update_ground_state()

	if is_grounded() && !is_sliding:
		add_jetpack_fuel(movement_resource.jetpack_fuel_recharge_rate * delta)

func sprint(is_sprinting: bool) -> void:
	sprint_input = is_sprinting


func is_moving() -> bool:
	return movement_vector.x != 0 or movement_vector.z != 0

func is_grounded() -> bool:
	return player_ground_state == Enums.PlayerGroundState.ON_GROUND

func crouch(is_crouching: bool) -> void:
	crouch_input = is_crouching


func update_ground_state() -> void:
	if parent_character.is_on_floor():
		player_ground_state = Enums.PlayerGroundState.ON_GROUND
	else:
		player_ground_state = Enums.PlayerGroundState.IN_AIR

	emit_signal("ground_state_changed", player_ground_state)


func remove_jetpack_fuel(amount: float) -> void:
	jetpack_fuel -= amount
	if jetpack_fuel < 0.0:
		jetpack_fuel = 0.0

func add_jetpack_fuel(amount: float) -> void:
	jetpack_fuel += amount
	if jetpack_fuel > 100.0:
		jetpack_fuel = 100.0
