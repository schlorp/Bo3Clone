extends State
class_name JetpackState

var jetpack_force: float
var jetpack_fuel_consumption_rate: float = 1.0


func _init(_statemachine: StateMachine) -> void:
	super._init(_statemachine)
	state_name = "JetpackState"

	jetpack_force = state_machine.movement_node.movement_resource.jetpack_force
	jetpack_fuel_consumption_rate = state_machine.movement_node.movement_resource.jetpack_fuel_consumption_rate

func setup_transitions() -> void:
	add_transition(
		Transition.new(
			self,
			state_machine.available_states["FallingState"],
			func():	return Input.is_action_just_released("game_jump") || state_machine.movement_node.jetpack_fuel <= 0
		)
	)

func enter_state() -> void:
	state_machine.movement_node.is_jetpack_active = true

func update_state(delta: float) -> void:
	state_machine.movement_node.movement_vector.y = jetpack_force * delta

	state_machine.movement_node.remove_jetpack_fuel(jetpack_fuel_consumption_rate * delta)

func exit_state() -> void:
	state_machine.movement_node.is_jetpack_active = false
	state_machine.movement_node.jump_basis = state_machine.movement_node.parent_character.transform.basis