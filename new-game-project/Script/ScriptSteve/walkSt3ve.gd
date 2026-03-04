extends State
@export var Steve: CharacterBody2D
@export var anim: AnimatedSprite2D

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var speed := 400
var player_number : int = 0

func _ready() -> void:
	detect_player_number()
		
func detect_player_number() -> void:
	var state_machine = get_parent()  # This is the StateMachine node
	var root = state_machine.get_parent()  # This is the Node2D root
	
	print("Walk state - detecting player for: ", root.name)
	
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
		print("⚠️ Walk ERROR: Could not find CharacterBody2D!")
		return
	
	# Check if character has a player_number property set
	if character.has_meta("player_number"):
		player_number = character.get_meta("player_number")
		print("✅ Walk - Player number: ", player_number, " for ", character.name)
		return
	
	# Fallback: check position in players group
	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			print("✅ Walk - Player number from group: ", player_number)
			return
		
func enter() -> void:
	print("Entered walk - Player ", player_number)
	pass

func Physics_Update(delta: float) -> void:
	if not Steve:
		print("⚠️ Walk - Steve is null!")
		return
		
	if player_number == 1:
		var dir_x := Input.get_axis("leftp1", "rightp1")
		Steve.velocity.x = dir_x * speed
		anim.play("walk")
		
		# Update punch cooldown
		var punch_state = get_parent().states.get("punch")
		if punch_state:
			punch_state.update_cooldown(delta)
		
		# Update kick cooldown
		var kick_state = get_parent().states.get("kick")
		if kick_state:
			kick_state.update_cooldown(delta)
		
		# Punch input
		if Input.is_action_just_pressed("punchp1"):
			if punch_state and punch_state.can_punch():
				Transitioned.emit(self, "punch")
				return
			else:
				print("Punch on cooldown!")
		
		# Kick input
		if Input.is_action_just_pressed("kickp1"):
			if kick_state and kick_state.can_kick():
				Transitioned.emit(self, "kick")
				return
			else:
				print("Kick on cooldown!")
		
		# Jump input
		if Input.is_action_just_pressed("jumpp1") and Steve.is_on_floor():
			Transitioned.emit(self, "jump")
			return
		if Input.is_action_just_pressed("blockp1"):  # inside player_number == 1 block
			Transitioned.emit(self, "block")
			return
		
		# Gravity
		if not Steve.is_on_floor():
			Steve.velocity.y += gravity * delta
		
		Steve.move_and_slide()
		
		# Idle transition - check AFTER movement
		if dir_x == 0:
			Transitioned.emit(self, "idle")
			return

	elif player_number == 2:
		var dir_x := Input.get_axis("leftp2", "rightp2")
		Steve.velocity.x = dir_x * speed
		anim.play("walk")
		
		# Update punch cooldown
		var punch_state = get_parent().states.get("punch")
		if punch_state:
			punch_state.update_cooldown(delta)
		
		# Update kick cooldown
		var kick_state = get_parent().states.get("kick")
		if kick_state:
			kick_state.update_cooldown(delta)
		
		# Punch input
		if Input.is_action_just_pressed("punchp2"):
			if punch_state and punch_state.can_punch():
				Transitioned.emit(self, "punch")
				return
			else:
				print("Punch on cooldown!")
		
		# Kick input
		if Input.is_action_just_pressed("kickp2"):
			if kick_state and kick_state.can_kick():
				Transitioned.emit(self, "kick")
				return
			else:
				print("Kick on cooldown!")
		
		# Jump input
		if Input.is_action_just_pressed("jumpp2") and Steve.is_on_floor():
			Transitioned.emit(self, "jump")
			return
		if Input.is_action_just_pressed("blockp2"):  # inside player_number == 2 block
			Transitioned.emit(self, "block")
			return
		
		# Gravity
		if not Steve.is_on_floor():
			Steve.velocity.y += gravity * delta
		
		Steve.move_and_slide()
		
		# Idle transition - check AFTER movement
		if dir_x == 0:
			Transitioned.emit(self, "idle")
			return
	else:
		print("⚠️ Unknown player_number: ", player_number)
