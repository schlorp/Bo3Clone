extends BaseDamagable

@export var mesh: MeshInstance3D

@export_group("Timings")
@export var flash_duration: float = 0.1
@export var respawn_time: float = 2.0

@onready var original_material := mesh.get_active_material(0)
var flash_material: StandardMaterial3D

func _ready() -> void:
	super._ready()

	flash_material = original_material.duplicate()
	flash_material.albedo_color = Color(0, 50, 0)  # Red color for flash effect

func handle_death() -> void:

	mesh.visible = false
	await (get_tree().create_timer(respawn_time).timeout)

	mesh.visible = true
	mesh.set_surface_override_material(0, original_material)
	reset_health()

func apply_damage(damage_amount: int) -> void:
	super.apply_damage(damage_amount)
	flash_on_damage()

func flash_on_damage() -> void:
	if mesh == null:
		return

	mesh.set_surface_override_material(0, flash_material)
	await (get_tree().create_timer(flash_duration).timeout)
	mesh.set_surface_override_material(0, original_material)
