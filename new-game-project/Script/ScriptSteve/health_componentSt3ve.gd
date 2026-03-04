extends Node2D

@export var max_health := 20
var health: int
var healthbar: TextureProgressBar
var player_number: int = 0

func _ready() -> void:
	health = max_health
	await get_tree().process_frame
	
	if player_number == 0:
		detect_player_number()
	
	var group_name = "p" + str(player_number) + "_healthbar"
	var healthbars = get_tree().get_nodes_in_group(group_name)
	if healthbars.size() > 0:
		healthbar = healthbars[0]
		healthbar.max_value = max_health
		print("✅ HealthComponent (Player ", player_number, ") found healthbar: ", healthbar.name)
	else:
		print("⚠️ No healthbar found for group: ", group_name)
	
	update_healthbar()

func detect_player_number() -> void:
	# Layout: HealthComponent -> Pain(Area2D) -> CharacterBody2D -> Node2D(root)
	var pain = get_parent()             # Pain Area2D
	var character_body = pain.get_parent()  # CharacterBody2D
	
	# Check meta first (set by main.gd at spawn)
	if character_body.has_meta("player_number"):
		player_number = character_body.get_meta("player_number")
		print("✅ HealthComponent detected player: ", player_number, " via meta on ", character_body.name)
		return
	
	# Fallback: search players group
	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character_body:
			player_number = i + 1
			print("✅ HealthComponent detected player: ", player_number, " via group")
			return
	
	print("⚠️ HealthComponent could not detect player number!")

func update_healthbar() -> void:
	if healthbar:
		healthbar.value = health

func damage(attack_damage: int, 
	attack_type: String = "unknown") -> void:
	health -= attack_damage
	health = max(health, 0)
	update_healthbar()
	
	if health <= 0:
		die()

func die() -> void:
	# Layout: HealthComponent -> Pain -> CharacterBody2D -> Node2D(root)
	var character_root = get_parent().get_parent().get_parent()  # Node2D root
	print(character_root.name, " has died!")
	character_root.queue_free()  # Frees the entire character including all children
