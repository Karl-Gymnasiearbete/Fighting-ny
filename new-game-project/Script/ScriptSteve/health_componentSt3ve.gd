extends Node2D

@export var max_health := 10
var health : int
var healthbar : TextureProgressBar
var player_number : int = 0  # Will be set by main scene

func _ready() -> void:
	health = max_health
	# Wait for player_number to be assigned
	await get_tree().process_frame
	
	if player_number == 0:
		# If not assigned, try to detect
		detect_player_number()
	
	# Find the healthbar by group based on player number
	var group_name = "p" + str(player_number) + "_healthbar"
	var healthbars = get_tree().get_nodes_in_group(group_name)
	if healthbars.size() > 0:
		healthbar = healthbars[0]
		healthbar.max_value = max_health
	update_healthbar()

func detect_player_number() -> void:
	var character = get_parent()
	# Use the character's position in the tree or a marker
	# This assumes player 1 is spawned first
	var all_characters = get_tree().get_nodes_in_group("players")
	for i in range(all_characters.size()):
		if all_characters[i] == character:
			player_number = i + 1
			return
	
	# Fallback: check Global
	if character.name == Global.p1_character or character.name.begins_with(Global.p1_character):
		player_number = 1
	else:
		player_number = 2

func update_healthbar() -> void:
	if healthbar:
		healthbar.value = health
	
	var label = get_parent().get_node_or_null("Label")
	if label:
		label.text = str(health) + "hp"

func damage(attack) -> void:
	health -= attack
	health = max(health, 0)
	update_healthbar()
	
	if health <= 0:
		print(get_parent().name + " Died")
		get_parent().queue_free()
