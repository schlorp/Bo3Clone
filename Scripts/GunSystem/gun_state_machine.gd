extends StateMachine

@export var gun: BaseGun

func fill_available_states() -> void:
	var idle_state = IdleGunState.new(self)
	var firing_state = FiringGunState.new(self)
	var empty_state = EmptyGunState.new(self)
	var reload_state = ReloadGunState.new(self)
	var cycling_state = CyclingGunState.new(self)

	_available_states = {
		idle_state.state_name: idle_state,
		firing_state.state_name: firing_state,
		empty_state.state_name: empty_state,
		reload_state.state_name: reload_state,
		cycling_state.state_name: cycling_state
	}

	for state in _available_states.values():
		state.setup_transitions()

func _ready() -> void:
	super._ready()
	switch_to_state("IdleState")

func _process(delta: float) -> void:
	super._process(delta)
	print("Current State: %s" % current_state.state_name)