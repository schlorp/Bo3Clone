extends Node3D
class_name CameraController

@export var mouse_sensitivity: float = 0.1
@export var up_and_down_clamp: float = 89.0
@onready var player_character: CharacterBody3D = get_parent() as CharacterBody3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func rotate_camera(given_rotation: Vector2) -> void:
	player_character.rotate_y(deg_to_rad(-given_rotation.x * mouse_sensitivity))

	rotate_x(deg_to_rad(-given_rotation.y * mouse_sensitivity))
	rotation.x = clamp(rotation.x, deg_to_rad(-up_and_down_clamp), deg_to_rad(up_and_down_clamp))


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_camera(event.relative)
			pass
