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
var is_automatic_cycling: bool

#fire modes
var available_fire_modes: Array[Enums.FireMode]
var default_fire_mode: Enums.FireMode
var current_fire_mode: Enums.FireMode

#burst stats
var burst_count: int
var current_burst_count: int = 0
var in_burst: bool = false
var burst_delay: float

#reload stats
var reload_time: float
var reload_time_empty: float

signal fired()
signal fire_mode_switched(new_fire_mode: Enums.FireMode)


func _ready() -> void:
	magazine_ammo = gun_data.magazine_ammo
	reserve_ammo = gun_data.reserve_ammo
	current_ammo = magazine_ammo

	fire_rate = gun_data.fire_rate
	damage = gun_data.damage
	is_automatic_cycling = gun_data.is_automatic_cycling

	available_fire_modes = gun_data.available_fire_modes
	default_fire_mode = gun_data.default_fire_mode
	current_fire_mode = default_fire_mode

	reload_time = gun_data.reload_time
	reload_time_empty = gun_data.reload_time_empty


func fire() -> void:
	if current_ammo > 0:
		current_ammo -= 1
		emit_signal("fired")
		print("Fired! Current Ammo: %d" % current_ammo)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("game_switch_fire_mode") && !in_burst:
		switch_fire_mode()


func switch_fire_mode() -> void:
	var current_index = available_fire_modes.find(current_fire_mode)
	var next_index = (current_index + 1) % available_fire_modes.size()
	current_fire_mode = available_fire_modes[next_index]

	emit_signal("fire_mode_switched", current_fire_mode)


func start_burst() -> void:
	if !in_burst:
		in_burst = true
		current_burst_count = 0


func reload() -> void:
	var is_empty = current_ammo <= 0
	var reload_duration = reload_time_empty if is_empty else reload_time

	print("Reloading... (Duration: %f seconds)" % reload_duration)
	await get_tree().create_timer(reload_duration).timeout

	var ammo_needed = magazine_ammo - current_ammo
	var ammo_to_reload = min(ammo_needed, reserve_ammo)

	current_ammo += ammo_to_reload
	reserve_ammo -= ammo_to_reload

	print("Reloaded! Current Ammo: %d, Reserve Ammo: %d" % [current_ammo, reserve_ammo])