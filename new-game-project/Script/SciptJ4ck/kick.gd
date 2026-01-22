extends State
@export var Steve: CharacterBody2D
var hit_box: Area2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

@export var kick_duration := 0.3
@export var hitbox_active_duration := 0.1
@export var kick_cooldown := 1.0
@export var anim: AnimatedSprite2D

var kick_timer := 0.0
var cooldown_timer := 0.0
var hitbox_disabled := false
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
	print("Entered kick - Player ", player_number)
	kick_timer = 0.0
	hitbox_disabled = false
	if anim:
		anim.play("kick")
	
	# Find HitBoxKick node if we don't have it yet
	if not hit_box and Steve:
		hit_box = Steve.find_child("HitBoxKick", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		
		if hit_box:
			print("✅ Found HitBoxKick:", hit_box.name)
		else:
			print("⚠️ HitBoxKick not found!")
			return
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox when kick starts
	if hit_box and hit_box.has_method("enable_hitbox"):
		print("Enabling kick hitbox")
		hit_box.enable_hitbox()

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	kick_timer += delta
	
	# Disable hitbox after short duration
	if kick_timer >= hitbox_active_duration and hit_box and not hitbox_disabled:
		if hit_box.has_method("disable_hitbox"):
			hit_box.disable_hitbox()
			hitbox_disabled = true
	
	# Apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
	
	# Exit kick state after animation completes
	if kick_timer >= kick_duration:
		if player_number == 1:
			var dir_x := Input.get_axis("leftp1", "rightp1")
			
			if not Steve.is_on_floor():
				Transitioned.emit(self, "idle")
			elif dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")
			return
			
		elif player_number == 2:
			var dir_x := Input.get_axis("leftp2", "rightp2")
			
			if not Steve.is_on_floor():
				Transitioned.emit(self, "idle")
			elif dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")
			return

func exit() -> void:
	print("Exiting kick, setting cooldown to ", kick_cooldown)
	kick_timer = 0.0
	cooldown_timer = kick_cooldown
	if hit_box and hit_box.has_method("disable_hitbox"):
		hit_box.disable_hitbox()

func can_kick() -> bool:
	var can_do = cooldown_timer <= 0.0
	if not can_do:
		print("Can't kick - cooldown: ", cooldown_timer)
	return can_do

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
