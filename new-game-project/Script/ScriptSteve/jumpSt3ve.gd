extends State

@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var jump_force := 450
@export var air_speed := 400
var player_number : int = 0

func _ready() -> void:
	detect_player_number()
		
# Replace the detect_player_number() function in ALL your state scripts with this:

func detect_player_number() -> void:
	var state_machine = get_parent()  # This is the StateMachine node
	var root = state_machine.get_parent()  # This is the Node2D root
	
	print("Detecting player for state in: ", root.name)
	
	# Find the CharacterBody2D
	var character = null
	if root is CharacterBody2D:
		character = root
	else:
		for child in root.get_children():
			if child is CharacterBody2D:
				character = child
				break
	
	if not character:
		print("⚠️ ERROR: Could not find CharacterBody2D!")
		return
	
	print("Found CharacterBody2D: ", character.name)
	
	# Check if character has a player_number property set
	if character.has_meta("player_number"):
		player_number = character.get_meta("player_number")
		print("✅ Player number from meta: ", player_number)
		return
	
	# Fallback: check position in players group
	var all_players = get_tree().get_nodes_in_group("players")
	print("Players in group: ", all_players.size())
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			print("✅ Player number from group position: ", player_number)
			return
	
	print("⚠️ WARNING: Could not determine player number!")

func enter() -> void:
	print("Entered jump - Player ", player_number)
	Steve.velocity.y = -jump_force

func Physics_Update(delta: float) -> void:
	var dir_x := 0.0

	if player_number == 1:
		dir_x = Input.get_axis("leftp1", "rightp1")

		if Input.is_action_just_pressed("punchp1"):
			Transitioned.emit(self, "punch")
			return

		if Input.is_action_just_pressed("kickp1"):
			Transitioned.emit(self, "kick")
			return

	elif player_number == 2:
		dir_x = Input.get_axis("leftp2", "rightp2")

		if Input.is_action_just_pressed("punchp2"):
			Transitioned.emit(self, "punch")
			return

		if Input.is_action_just_pressed("kickp2"):
			Transitioned.emit(self, "kick")
			return

	Steve.velocity.x = dir_x * air_speed
	Steve.velocity.y += gravity * delta
	Steve.move_and_slide()

	if Steve.is_on_floor():
		Transitioned.emit(self, "idle" if dir_x == 0 else "walk")
