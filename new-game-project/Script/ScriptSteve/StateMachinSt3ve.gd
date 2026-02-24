extends Node2D
@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	print("StateMachine ready")


	# Get reference to the root Node2D
	var root = get_parent()
	print("StateMachine parent (root): ", root.name, " (", root.get_class(), ")")
	
	# Find the CharacterBody2D - it should be a sibling or child of root
	var steve = null
	
	# First, check if root is the CharacterBody2D
	if root is CharacterBody2D:
		steve = root
	else:
		# Otherwise, look for CharacterBody2D among root's children
		for child in root.get_children():
			if child is CharacterBody2D:
				steve = child
				break
	
	if not steve:
		print("⚠️ ERROR: Could not find CharacterBody2D!")
		return
	
	print("✅ Found CharacterBody2D: ", steve.name)

	for child in get_children():
		if child is State:
			print("  Setting up state:", child.name, " for ", steve.name)
			states[child.name] = child

			# Set Steve reference for each state
			child.Steve = steve
			child.Transitioned.connect(on_child_transition)

	if initial_state:
		print("Starting with initial state:", initial_state.name)
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
	if state != current_state:
		return
		
	var new_state: State = states.get(new_state_name)
	if !new_state:
		print("⚠️ State not found:", new_state_name)
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
