extends State
@export var Steve: CharacterBody2D
@export var anim: AnimatedSprite2D

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
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
		return
	if character.has_meta("player_number"):
		player_number = character.get_meta("player_number")
		return
	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			return

func enter() -> void:
	if anim:
		anim.play("crouch")
	# Move hitboxes down when crouching
	var hitboxes = Steve.find_child("Hitboxes", true, false)
	if hitboxes:
		hitboxes.position.y = 18  # Adjust this value to fit your character

func exit() -> void:
	# Reset hitboxes position when leaving crouch
	var hitboxes = Steve.find_child("Hitboxes", true, false)
	if hitboxes:
		hitboxes.position.y = 0

func Physics_Update(delta: float) -> void:
	if not Steve:
		return

	# Apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	Steve.velocity.x = 0
	Steve.move_and_slide()

	var crouch_held = false

	if player_number == 1:
		crouch_held = Input.is_action_pressed("crouchp1")
		if Input.is_action_just_pressed("punchp1"):
			Transitioned.emit(self, "punch")
			return
		if Input.is_action_just_pressed("kickp1"):
			Transitioned.emit(self, "kick")
			return
	elif player_number == 2:
		crouch_held = Input.is_action_pressed("crouchp2")
		if Input.is_action_just_pressed("punchp2"):
			Transitioned.emit(self, "punch")
			return
		if Input.is_action_just_pressed("kickp2"):
			Transitioned.emit(self, "kick")
			return

	# Return to idle when crouch button released
	if not crouch_held:
		Transitioned.emit(self, "idle")
