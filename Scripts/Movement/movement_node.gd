extends Node
class_name MovementNode

@onready var parent_character: CharacterBody3D = get_parent() as CharacterBody3D
@export var input_parser: PlayerInputParseNode

@export var walk_speed: float = 350.0
@export var sprint_speed: float = 450.0
var crouch_speed: float = walk_speed * 0.5

@export var initial_slide_boost: float = 0.0

var current_movement_speed: float = walk_speed

@export var jump_force: float = 2.5

var _jump_basis: Basis

var player_ground_state: Enums.PlayerGroundState = Enums.PlayerGroundState.ON_GROUND
var _player_movement_state: Enums.PlayerMovementState = Enums.PlayerMovementState.IDLE

var movement_vector: Vector3 = Vector3.ZERO
var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

signal ground_state_changed(state: Enums.PlayerGroundState)
signal movement_state_changed(state: Enums.PlayerMovementState)

func _ready() -> void:
	input_parser.connect("on_movement_input", Callable(self, "handle_movement_input"))
	input_parser.connect("on_jump_input_just_pressed", Callable(self, "jump"))
	input_parser.connect("on_sprint_input", Callable(self, "sprint"))
	input_parser.connect("on_crouch_input", Callable(self, "crouch"))

func handle_movement_input(vector: Vector3) -> void:
	if player_ground_state == Enums.PlayerGroundState.IN_AIR:
		return

	var direction := Vector3.ZERO
	direction.x = vector.x
	direction.z = vector.z
	direction = direction.normalized()
	movement_vector.x = direction.x
	movement_vector.z = direction.z


func apply_movementvector(delta: float) -> void:
	if player_ground_state == Enums.PlayerGroundState.IN_AIR:
		parent_character.velocity = _jump_basis * movement_vector * current_movement_speed * delta 
	else: 
		parent_character.velocity = parent_character.transform.basis * movement_vector * current_movement_speed * delta 

	parent_character.move_and_slide()


func apply_gravity(delta: float) -> void:
	if !parent_character.is_on_floor():
		movement_vector.y -= _gravity * delta
	else:
		movement_vector.y = 0

func decellerate_slide(delta: float) -> void:
	if player_ground_state == Enums.PlayerGroundState.IN_AIR:
		return

	var deceleration_rate: float = 5.0
	if _player_movement_state == Enums.PlayerMovementState.SLIDING:
		current_movement_speed = max(current_movement_speed - deceleration_rate * delta, walk_speed)
		if current_movement_speed == walk_speed:
			_player_movement_state = Enums.PlayerMovementState.WALKING


func _physics_process(delta: float) -> void:
	apply_movementvector(delta)
	apply_gravity(delta)
	update_ground_state()
	update_movement_state()


func jump() -> void:
	if player_ground_state == Enums.PlayerGroundState.ON_GROUND:
		_jump_basis = parent_character.transform.basis
		movement_vector.y = jump_force


func sprint(is_sprinting: bool) -> void:
	if is_sprinting && player_ground_state == Enums.PlayerGroundState.ON_GROUND && _player_movement_state != Enums.PlayerMovementState.CROUCHING:
		current_movement_speed = sprint_speed
	elif !is_sprinting && _player_movement_state == Enums.PlayerMovementState.SPRINTING:
		current_movement_speed = walk_speed


func slide() -> void:
	# add a slide boost in the direction the player is currently moving
	var slide_direction = parent_character.transform.basis * movement_vector
	slide_direction.y = 0
	slide_direction = slide_direction.normalized()

	# set the movement state to sliding
	_player_movement_state = Enums.PlayerMovementState.SLIDING

	current_movement_speed = sprint_speed + initial_slide_boost


func is_moving() -> bool:
	return movement_vector.x != 0 or movement_vector.z != 0

func is_crouching() -> bool:
	return current_movement_speed == crouch_speed

func is_grounded() -> bool:
	return player_ground_state == Enums.PlayerGroundState.ON_GROUND


func crouch(is_crouching: bool) -> void:
	if is_crouching && player_ground_state == Enums.PlayerGroundState.ON_GROUND && _player_movement_state:
		if _player_movement_state == Enums.PlayerMovementState.SPRINTING:
			slide()
		else:
			current_movement_speed = crouch_speed
	elif !is_crouching && _player_movement_state == Enums.PlayerMovementState.CROUCHING:
		current_movement_speed = walk_speed


func update_ground_state() -> void:
	if parent_character.is_on_floor():
		player_ground_state = Enums.PlayerGroundState.ON_GROUND
	else:
		player_ground_state = Enums.PlayerGroundState.IN_AIR

	emit_signal("ground_state_changed", player_ground_state)


func update_movement_state() -> void:
	if player_ground_state == Enums.PlayerGroundState.IN_AIR:
		_player_movement_state = Enums.PlayerMovementState.IDLE
		return

	

	if current_movement_speed == sprint_speed:
		_player_movement_state = Enums.PlayerMovementState.SPRINTING
	
	elif current_movement_speed == crouch_speed:
		_player_movement_state = Enums.PlayerMovementState.CROUCHING

	elif movement_vector.x == 0 and movement_vector.z == 0:
		_player_movement_state = Enums.PlayerMovementState.IDLE

	else:
		_player_movement_state = Enums.PlayerMovementState.WALKING

	emit_signal("movement_state_changed", _player_movement_state)