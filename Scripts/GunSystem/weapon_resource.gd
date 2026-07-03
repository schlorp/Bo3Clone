extends Resource
class_name WeaponResource

@export_subgroup("Ammo stats")
@export var magazine_ammo: int = 30
@export var reserve_ammo: int = 90

@export_subgroup("Gun stats")
@export var fire_rate: float = 6.0
@export var damage: int = 10
@export var is_automatic: bool = true

@export_subgroup("Reload stats")
@export var reload_time: float = 2.0
@export var reload_time_empty: float = 3.0