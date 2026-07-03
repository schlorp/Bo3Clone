extends Node
class_name BaseGun

@export var gun_data: WeaponResource

#ammo stats
var magazine_ammo: int
var reserve_ammo: int
var current_ammo: int

#gun stats
var fire_rate: float
var damage: int
var is_automatic: bool

#reload stats
var reload_time: float
var reload_time_empty: float

signal fired()


func _ready() -> void:
	magazine_ammo = gun_data.magazine_ammo
	reserve_ammo = gun_data.reserve_ammo
	current_ammo = magazine_ammo

	fire_rate = gun_data.fire_rate
	damage = gun_data.damage
	is_automatic = gun_data.is_automatic

	reload_time = gun_data.reload_time
	reload_time_empty = gun_data.reload_time_empty


func fire() -> void:
	if current_ammo > 0:
		current_ammo -= 1
		emit_signal("fired")
		print("Fired! Current Ammo: %d" % current_ammo)
