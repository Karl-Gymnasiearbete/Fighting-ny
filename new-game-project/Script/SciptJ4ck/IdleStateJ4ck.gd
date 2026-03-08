extends State
@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var anim: AnimatedSprite2D
var player_number: int = 0

func _ready() -> void:
	detect_player_number()

func detect_player_number() -> void:
	var state_machine = get_parent()
	var root = state_machine.get_parent()

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

	if character.has_meta("player_number"):
		player_number = character.get_meta("player_number")
		print("✅ Player number from meta: ", player_number)
		return

	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			return

func enter() -> void:
	if anim:
		anim.play("Idle")
	var punch_state = get_parent().states.get("punch")
	if punch_state:
		punch_state.cooldown_timer = 0.0
	var kick_state = get_parent().states.get("kick")
	if kick_state:
		kick_state.cooldown_timer = 0.0

func Physics_Update(delta: float) -> void:
	if not is_instance_valid(Steve) or Steve.dead:
		return

	# Always apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta

	Steve.velocity.x = 0
	Steve.move_and_slide()

	var dir_x := 0.0

	if player_number == 1:
		dir_x = Input.get_axis("leftp1", "rightp1")
		if Input.is_action_just_pressed("blockp1"):
			Transitioned.emit(self, "block2")
			return
		if Input.is_action_just_pressed("punchp1"):
			Transitioned.emit(self, "punch2")
			return
		if Input.is_action_just_pressed("kickp1"):
			Transitioned.emit(self, "kick2")
			return
		if Input.is_action_just_pressed("jumpp1") and Steve.is_on_floor():
			Transitioned.emit(self, "jump")
			return
		if Input.is_action_pressed("crouchp1"):
			Transitioned.emit(self, "crouch")
			return
	elif player_number == 2:
		dir_x = Input.get_axis("leftp2", "rightp2")
		if Input.is_action_just_pressed("blockp2"):
			Transitioned.emit(self, "block2")
			return
		if Input.is_action_just_pressed("punchp2"):
			Transitioned.emit(self, "punch2")
			return
		if Input.is_action_just_pressed("kickp2"):
			Transitioned.emit(self, "kick2")
			return
		if Input.is_action_just_pressed("jumpp2") and Steve.is_on_floor():
			Transitioned.emit(self, "jump")
			return
		if Input.is_action_pressed("crouchp2"):
			Transitioned.emit(self, "crouch")
			return

	if dir_x != 0:
		Transitioned.emit(self, "walk")
