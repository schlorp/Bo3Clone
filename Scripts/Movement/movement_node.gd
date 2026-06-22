extends Node
class_name MovementNode

@onready var parent_character: CharacterBody3D = get_parent() as CharacterBody3D
@export var input_parser: PlayerInputParseNode

@export var walk_speed: float = 350.0
@export var sprint_speed: float = 450.0

var _current_movement_speed: float = walk_speed

@export var jump_force: float = 2.5

var _jump_basis: Basis

var _player_ground_state: Enums.PlayerGroundState = Enums.PlayerGroundState.ON_GROUND
var _player_movement_state: Enums.PlayerMovementState = Enums.PlayerMovementState.IDLE

var _movement_vector: Vector3 = Vector3.ZERO
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal ground_state_changed(state: Enums.PlayerGroundState)
signal movement_state_changed(state: Enums.PlayerMovementState)

func _ready() -> void:
	input_parser.connect("on_movement_input", Callable(self, "handle_movement_input"))
	input_parser.connect("on_jump_input_just_pressed", Callable(self, "jump"))
	input_parser.connect("on_sprint_input", Callable(self, "sprint"))


func handle_movement_input(vector: Vector3) -> void:
	if _player_ground_state == Enums.PlayerGroundState.IN_AIR:
		return

	var direction := Vector3.ZERO
	direction.x = vector.x
	direction.z = vector.z
	direction = direction.normalized()
	_movement_vector.x = direction.x
	_movement_vector.z = direction.z


func apply_movementvector(delta: float) -> void:
	if _player_ground_state == Enums.PlayerGroundState.IN_AIR:
		parent_character.velocity = _jump_basis * _movement_vector * _current_movement_speed * delta 
	else: 
		parent_character.velocity = parent_character.transform.basis * _movement_vector * _current_movement_speed * delta 

	parent_character.move_and_slide()


func apply_gravity(delta: float) -> void:
	if !parent_character.is_on_floor():
		_movement_vector.y -= _gravity * delta
	else:
		_movement_vector.y = 0


func _physics_process(delta: float) -> void:
	apply_movementvector(delta)
	apply_gravity(delta)
	update_ground_state()
	update_movement_state()


func jump() -> void:
	if _player_ground_state == Enums.PlayerGroundState.ON_GROUND:
		_jump_basis = parent_character.transform.basis
		_movement_vector.y = jump_force


func sprint(is_sprinting: bool) -> void:
	if is_sprinting:
		_current_movement_speed = sprint_speed
	else:
		_current_movement_speed = walk_speed


func update_ground_state() -> void:
	if parent_character.is_on_floor():
		_player_ground_state = Enums.PlayerGroundState.ON_GROUND
	else:
		_player_ground_state = Enums.PlayerGroundState.IN_AIR

	emit_signal("ground_state_changed", _player_ground_state)


func update_movement_state() -> void:
	if _player_ground_state == Enums.PlayerGroundState.IN_AIR:
		_player_movement_state = Enums.PlayerMovementState.IDLE
		return

	if _movement_vector.x == 0 and _movement_vector.z == 0:
		_player_movement_state = Enums.PlayerMovementState.IDLE
	elif _current_movement_speed == walk_speed:
		_player_movement_state = Enums.PlayerMovementState.WALKING
	elif _current_movement_speed == sprint_speed:
		_player_movement_state = Enums.PlayerMovementState.SPRINTING

	emit_signal("movement_state_changed", _player_movement_state)