extends Resource
class_name MovementResource

@export_subgroup("Walk")
@export var walk_speed: float = 350.0
@export var walk_animation_speed: float = 1.0

@export_subgroup("Sprint")
@export var sprint_speed: float = 550.0
@export var sprint_animation_speed: float = 2.0

@export_subgroup("Crouch")
@export var crouch_speed: float = 175.0
@export var crouch_height: float = 1.0
@export var crouch_radius: float = 0.25
@export var stand_height: float = 2.0
@export var stand_radius: float = 0.5

@export_subgroup("Jump")
@export var jump_force: float = 1.5

@export_subgroup("Jetpack")
@export var jetpack_force: float = 50
@export var jetpack_fuel_consumption_rate: float = 100.0
@export var jetpack_fuel_recharge_rate: float = 150.0

@export_subgroup("Slide")
@export var slide_start_speed: float = 950.0
@export var slide_deceleration: float = 150.0
@export var slide_min_speed: float = 800.0
@export var slide_height: float = 0.75
@export var slide_radius: float = 0.25