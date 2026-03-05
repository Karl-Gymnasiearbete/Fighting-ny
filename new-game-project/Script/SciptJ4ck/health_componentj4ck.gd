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
	
	print("Player number after detect: ", player_number)
	
	var group_name = "p" + str(player_number) + "_healthbar"
	print("Looking for group: ", group_name)
	
	var healthbars = get_tree().get_nodes_in_group(group_name)
	if healthbars.size() > 0:
		healthbar = healthbars[0]
		healthbar.max_value = max_health
		print("✅ Found healthbar: ", healthbar.name, " max set to: ", max_health)
	else:
		print("⚠️ No healthbar found for group: ", group_name)
	
	update_healthbar()

func detect_player_number() -> void:
	var pain = get_parent()
	var hitboxes = pain.get_parent()
	var character_body = hitboxes.get_parent()
	
	if character_body.has_meta("player_number"):
		player_number = character_body.get_meta("player_number")
		print("✅ HealthComponent detected player: ", player_number, " via meta on ", character_body.name)
		return
	
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
		print("✅ Healthbar updated to: ", health, "/", max_health)
	else:
		print("⚠️ update_healthbar called but healthbar is null!")

func damage(attack_damage: int, attack_type: String = "unknown") -> void:
	health -= attack_damage
	health = max(health, 0)
	update_healthbar()
	
	print(get_parent().get_parent().name, " took ", attack_damage, " ", attack_type, " damage! Health: ", health, "/", max_health)
	
	if health <= 0:
		die()

func die():
	print("💀 Player ", player_number, " has died! Winner is Player ", (2 if player_number == 1 else 1))
	
	var winner = 2 if player_number == 1 else 1
	
	# Disable the character body so it stops moving
	var pain = get_parent()
	var hitboxes = pain.get_parent()
	var character_body = hitboxes.get_parent()
	character_body.set_physics_process(false)
	character_body.set_process(false)
	
	# Find main scene more reliably
	var main = get_tree().get_root().get_node_or_null("Level")
	if main == null:
		# Try first child as fallback
		main = get_tree().get_root().get_child(0)
	
	print("Main scene found: ", main.name if main else "NULL")
	
	if main and main.has_method("show_win_screen"):
		main.show_win_screen(winner)
	else:
		print("⚠️ Could not find show_win_screen!")
