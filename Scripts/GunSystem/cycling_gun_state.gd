extends State
class_name CyclingGunState

var cycling_done: bool = false

var is_automatic: bool
var fire_rate: float

signal cycled_input()


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "CyclingState"


func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["IdleState"],
			func():	return cycling_done
		)
	)


func update_state(_delta: float) -> void:
	if Input.is_action_just_pressed("game_fire"):
			cycled_input.emit()


func enter_state() -> void:
	is_automatic = state_machine.gun.gun_data.is_automatic
	fire_rate = state_machine.gun.gun_data.fire_rate

	cycling_done = false
	
	await cycle()

	cycling_done = true


func cycle() -> void:
	print(is_automatic)
	if is_automatic:
		await state_machine.get_tree().create_timer(fire_rate).timeout
	else:
		await cycled_input
		await state_machine.get_tree().create_timer(fire_rate).timeout