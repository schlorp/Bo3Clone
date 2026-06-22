extends Node
class_name PlayerInputParseNode

signal on_movement_input(vector: Vector3)

signal on_jump_input_just_pressed()

signal on_fire_input_just_pressed()
signal on_fire_input()
signal on_fire_input_released()

signal on_aim_input_just_pressed()
signal on_aim_input_released()

signal on_reload_input_just_pressed()

signal on_switch_fire_mode_input_just_pressed()

signal on_item_switch_input(index: int)

signal on_sprint_input(is_sprinting: bool)

func _process(delta: float) -> void:
	handle_movement_input()
	handle_mouse_input()
	handle_reload_input()
	handle_fire_mode_switch_input()
	handle_item_switch_input()
	handle_jump_input()
	handle_sprint_input()

func handle_movement_input() -> void:
	var movement_vector := Vector3.ZERO

	if Input.is_action_pressed("game_move_forward"):
		movement_vector.z -= 1
	if Input.is_action_pressed("game_move_backward"):
		movement_vector.z += 1
	if Input.is_action_pressed("game_move_left"):
		movement_vector.x -= 1
	if Input.is_action_pressed("game_move_right"):
		movement_vector.x += 1

	emit_signal("on_movement_input", movement_vector)

func handle_mouse_input() -> void:
	if Input.is_action_just_pressed("game_fire"):
		emit_signal("on_fire_input_just_pressed")
	if Input.is_action_just_released("game_fire"):
		emit_signal("on_fire_input_released")
	if Input.is_action_pressed("game_fire"):
		emit_signal("on_fire_input")

	if Input.is_action_just_pressed("game_aim"):
		emit_signal("on_aim_input_just_pressed")
	if Input.is_action_just_released("game_aim"):
		emit_signal("on_aim_input_released")

func handle_reload_input() -> void:
	if Input.is_action_just_pressed("game_reload_gun"):
		emit_signal("on_reload_input_just_pressed")

func handle_fire_mode_switch_input() -> void:
	if Input.is_action_just_pressed("game_switch_fire_mode"):
		emit_signal("on_switch_fire_mode_input_just_pressed")

func handle_item_switch_input() -> void:
	if Input.is_action_just_pressed("game_switch_key_1"):
		emit_signal("on_item_switch_input", 0)
	if Input.is_action_just_pressed("game_switch_key_2"):
		emit_signal("on_item_switch_input", 1)

func handle_jump_input() -> void:
	if Input.is_action_just_pressed("game_jump"):
		emit_signal("on_jump_input_just_pressed")

func handle_sprint_input() -> void:
	if Input.is_action_pressed("game_sprint"):
		emit_signal("on_sprint_input", true)
	else:
		emit_signal("on_sprint_input", false)