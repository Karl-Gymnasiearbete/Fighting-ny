extends Node

# Define spawn positions directly if you don't have spawn point nodes
var p1_spawn_pos = Vector2(400, 300)  # Adjust these coordinates to fit your arena
var p2_spawn_pos = Vector2(600, 300)  # Adjust these coordinates to fit your arena
# At the top, add a reference to the win screen
@onready var win_screen = $WinScreen
@onready var win_label = $WinScreen/WinLabel
@onready var retry_button = $WinScreen/RetryButton
@onready var quit_button = $WinScreen/QuitButton



func show_win_screen(winning_player: int):
	win_label.text = "Player " + str(winning_player) + " Wins!"
	win_screen.visible = true
	get_tree().paused = true  # freeze the game

func _on_retry_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scener/HUb/mainMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
	
func _ready():
	win_screen.visible = false
	retry_button.pressed.connect(_on_retry_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	# Try to find spawn points in the scene first
	var p1_spawn = get_node_or_null("P1SpawnPoint")
	var p2_spawn = get_node_or_null("P2SpawnPoint")
	
	# If spawn points exist, use them; otherwise use default positions
	var p1_position = p1_spawn.global_position if p1_spawn else p1_spawn_pos
	var p2_position = p2_spawn.global_position if p2_spawn else p2_spawn_pos
	
	# Setup inputs before spawning
	Global.setup_inputs()
	
	print("=== Starting Character Spawn ===")
	
	# Spawn player 1
	spawn_character(Global.p1_character, 1, p1_position)
	
	# Spawn player 2
	spawn_character(Global.p2_character, 2, p2_position)
	
	print("=== Character Spawn Complete ===")

func spawn_character(character_name: String, player_num: int, position: Vector2):
	var character_scene
	
	# Load the appropriate character scene
	if character_name == "J4ck":
		character_scene = preload("res://Character/J4ck.tscn")  # Update with your actual path
	elif character_name == "St3ve":
		character_scene = preload("res://Character/St3ve.tscn")  # Update with your actual path
	else:
		print("⚠️ Unknown character: ", character_name)
		return
	
	# Instantiate the character
	var character_root = character_scene.instantiate()
	
	print("\n--- Spawning ", character_name, " as Player ", player_num, " ---")
	print("Root node type: ", character_root.get_class())
	print("Root node children: ", character_root.get_child_count())
	
	# Find the CharacterBody2D child
	var character_body = null
	for child in character_root.get_children():
		print("  Child: ", child.name, " (", child.get_class(), ")")
		if child is CharacterBody2D:
			character_body = child
			break
	
	if not character_body:
		print("⚠️ ERROR: No CharacterBody2D found in ", character_name, " scene!")
		print("Make sure your character scene has a CharacterBody2D node")
		character_root.queue_free()
		return
	
	print("✅ Found CharacterBody2D: ", character_body.name)
	
	# Set position on the root Node2D
	character_root.global_position = position
	
	# CRITICAL: Set the player_number on the CharacterBody2D
	character_body.set_meta("player_number", player_num)
	print("Set player_number meta to: ", player_num)
	
	# Give the root a unique name
	character_root.name = character_name + "_Root_P" + str(player_num)
	character_body.name = character_name + "_P" + str(player_num)
	
	# Add the CharacterBody2D to players group
	character_body.add_to_group("players")
	print("Added to 'players' group")
	
	# Add to the scene
	add_child(character_root)
	
	print("✅ Successfully spawned at position: ", position)
	
	# Verify the state machine can find the character
	var state_machine = character_body.get_node_or_null("StateMachine")
	if state_machine:
		print("✅ State machine found: ", state_machine.name)
	else:
		print("⚠️ WARNING: No StateMachine found on CharacterBody2D!")
