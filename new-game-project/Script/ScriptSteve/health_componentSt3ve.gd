extends Node2D

@export var max_health := 10
var health : int
var healthbar : TextureProgressBar
var player_number : int

func _ready() -> void:
	health = max_health
	# Auto-detect which player this is
	detect_player_number()
	# Find the healthbar by group based on player number
	await get_tree().process_frame
	var group_name = "p" + str(player_number) + "_healthbar"
	var healthbars = get_tree().get_nodes_in_group(group_name)
	if healthbars.size() > 0:
		healthbar = healthbars[0]
		healthbar.max_value = max_health
	update_healthbar()

func detect_player_number() -> void:
	var character = get_parent()
	# Check if this character matches p1 or p2
	if character.name == Global.p1_character or character.name.begins_with(Global.p1_character):
		player_number = 1
	elif character.name == Global.p2_character or character.name.begins_with(Global.p2_character):
		player_number = 2
	else:
		print("Warning: Could not detect player number for ", character.name)
		player_number = 1  # Default to player 1

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
