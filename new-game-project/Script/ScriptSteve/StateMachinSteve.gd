extends Node

@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	print("StateMachine ready")
	for child in get_children():
		if child is State:
			print("Found state:", child.name)
			states[child.name] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		print("Initial state:", initial_state.name)
		initial_state.enter()
		current_state = initial_state
	else:
		print("⚠️ No initial_state set!")

func _process(delta: float) -> void:
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.Physics_Update(delta)

func on_child_transition(state, new_state_name: String) -> void:
	print("Transition request:", state.name, "->", new_state_name)
	if state != current_state:
		print("Ignored transition from inactive state:", state.name)
		return

	var new_state: State = states.get(new_state_name)
	if !new_state:
		print("⚠️ State not found:", new_state_name)
		print("Available states:", states.keys())
		return

	print("✅ Switching to state:", new_state_name)
	if current_state:
		current_state.exit()
	new_state.enter()
	current_state = new_state
