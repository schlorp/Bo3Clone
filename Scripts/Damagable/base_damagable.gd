extends Node
class_name BaseDamagable

@export_group("Health Stats")
@export var max_health: int = 100
var current_health: int = 100

func _ready() -> void:
	reset_health()

func apply_damage(damage_amount: int) -> void:
	current_health -= damage_amount
	current_health = clamp(current_health, 0, max_health)
	if current_health <= 0:
		handle_death()

func handle_death() -> void:
	print("%s has died." % [self.name])

func reset_health() -> void:
	current_health = max_health