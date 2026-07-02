extends Node
class_name BaseGun

var gun_data: WeaponResource

var magazine_ammo: int
var reserve_ammo: int
var current_ammo: int

var fire_rate: float
var damage: int

var reload_time: float
var reload_time_empty: float


func _ready() -> void:
	magazine_ammo = gun_data.magazine_ammo
	reserve_ammo = gun_data.reserve_ammo
	current_ammo = magazine_ammo

	fire_rate = gun_data.fire_rate
	damage = gun_data.damage

	reload_time = gun_data.reload_time
	reload_time_empty = gun_data.reload_time_empty