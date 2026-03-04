extends State
@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var anim: AnimatedSprite2D
@export var damage_reduction := 0.5
var player_number: int = 0
var is_blocking := false
var just_entered := false

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
		return

	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			return

func enter() -> void:
	print("Entered block - Player ", player_number)
	just_entered = true
	is_blocking = true
	Steve.set_meta("is_blocking", true)
	Steve.set_meta("damage_reduction", damage_reduction)
	if anim:
		anim.play("block")

func Physics_Update(delta: float) -> void:
	if not Steve:
		return

	if just_entered:
		just_entered = false
		return

	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta

	Steve.velocity.x = 0
	Steve.move_and_slide()

	if player_number == 1:
		if not Input.is_action_pressed("blockp1"):
			var dir_x := Input.get_axis("leftp1", "rightp1")
			if dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")
	elif player_number == 2:
		if not Input.is_action_pressed("blockp2"):
			var dir_x := Input.get_axis("leftp2", "rightp2")
			if dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")

func exit() -> void:
	print("Exiting block - Player ", player_number)
	is_blocking = false
	Steve.set_meta("is_blocking", false)
	Steve.set_meta("damage_reduction", 1.0)
