extends Node2D
@export var initial_state: State
var current_state: State
var states: Dictionary = {}

func _ready() -> void:
	print("StateMachine ready")
	var root = get_parent()
	print("StateMachine parent (root): ", root.name, " (", root.get_class(), ")")

	var steve = null
	if root is CharacterBody2D:
		steve = root
	else:
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
	update_facing()

func update_facing() -> void:
	var root = get_parent()
	var my_body: CharacterBody2D = null
	if root is CharacterBody2D:
		my_body = root
	else:
		for child in root.get_children():
			if child is CharacterBody2D:
				my_body = child
				break
	if not my_body:
		return

	var all_players = get_tree().get_nodes_in_group("players")
	var opponent: CharacterBody2D = null
	for player in all_players:
		if player != my_body:
			opponent = player
			break
	if not opponent:
		return

	var diff = opponent.global_position.x - my_body.global_position.x
	if abs(diff) < 10:
		return

	var face_right = diff > 0

	# Flip sprite visually
	var sprite = my_body.find_child("AnimatedSprite2D", true, false)
	if sprite:
		if face_right:
			sprite.flip_h = false
			sprite.position.x = abs(sprite.position.x)  # positive offset
		else:
			sprite.flip_h = true
			sprite.position.x = -abs(sprite.position.x)  # negative offset

		# Flip hitboxes to match
	var hitboxes = my_body.find_child("Hitboxes", true, false)
	if hitboxes:
		if face_right:
			hitboxes.scale.x = 1
			hitboxes.position.x = 0
		else:
			hitboxes.scale.x = -1
			hitboxes.position.x = -5
		
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
