extends StateMachine
class_name MovementStateMachine

@export var movement_node: MovementNode
@export var animation_player: AnimationPlayer
@export var collision_shape: CollisionShape3D
@export var head_hitter_shape_cast: ShapeCast3D

var can_slide: bool = true
var slide_cooldown: float
var current_slide_cooldown: float = 0.0


signal on_state_changed(state: State)


func fill_available_states() -> void:
	var idle_state = IdleState.new(self)
	var walking_state = WalkingState.new(self)
	var sprinting_state = SprintingState.new(self)
	var jumping_state = JumpingState.new(self)
	var crouch_state = CrouchState.new(self)
	var slide_state = SlideState.new(self)
	var jetpack_state = JetpackState.new(self)
	var falling_state = FallingState.new(self)

	_available_states = {
		idle_state.state_name: idle_state,
		walking_state.state_name: walking_state,
		sprinting_state.state_name: sprinting_state,
		jumping_state.state_name: jumping_state,
		crouch_state.state_name: crouch_state,
		slide_state.state_name: slide_state,
		jetpack_state.state_name: jetpack_state,
		falling_state.state_name: falling_state
	}

	for state in _available_states.values():
		state.setup_transitions()


func switch_to_state(state_name: String) -> void:
	super.switch_to_state(state_name)
	emit_signal("on_state_changed", current_state)


func _ready() -> void:
	super._ready()

	slide_cooldown = movement_node.movement_resource.slide_cooldown

	switch_to_state("IdleState")


func start_slide_cooldown() -> void:
	can_slide = false
	current_slide_cooldown = slide_cooldown


func slide_timer(delta: float) -> void:
	if !can_slide:
		current_slide_cooldown -= delta
		if current_slide_cooldown <= 0.0:
			can_slide = true
			current_slide_cooldown = 0.0


func _process(delta: float) -> void:
	super._process(delta)
	slide_timer(delta)