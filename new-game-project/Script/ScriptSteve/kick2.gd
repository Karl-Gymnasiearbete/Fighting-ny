extends State
@export var Steve: CharacterBody2D
var hit_box: Area2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

@export var kick_duration := 0.8
@export var hitbox_active_duration := 0.1
@export var windup_duration := 0.5
@export var kick_cooldown := 1.0
@export var anim: AnimatedSprite2D

var kick_timer := 0.0
var cooldown_timer := 0.0
var hitbox_disabled := false
var hitbox_enabled := false
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
		return

	var all_players = get_tree().get_nodes_in_group("players")
	for i in range(all_players.size()):
		if all_players[i] == character:
			player_number = i + 1
			character.set_meta("player_number", player_number)
			return

func enter() -> void:
	kick_timer = 0.0
	hitbox_disabled = false
	hitbox_enabled = false
	if anim:
		anim.play("kick")

	if not hit_box and Steve:
		hit_box = Steve.find_child("HitBoxKick", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBoxKickSteve", true, false)
		if not hit_box:
			print("⚠️ Kick hitbox not found!")
			return

	if Steve:
		Steve.velocity.x = 0

func Physics_Update(delta: float) -> void:
	if not Steve:
		return

	kick_timer += delta

	if kick_timer >= windup_duration and not hitbox_enabled:
		hitbox_enabled = true
		if hit_box and hit_box.has_method("enable_hitbox"):
			hit_box.enable_hitbox()

	if kick_timer >= windup_duration + hitbox_active_duration and not hitbox_disabled:
		hitbox_disabled = true
		if hit_box and hit_box.has_method("disable_hitbox"):
			hit_box.disable_hitbox()

	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta

	Steve.move_and_slide()

	if kick_timer >= kick_duration:
		if player_number == 1:
			var dir_x := Input.get_axis("leftp1", "rightp1")
			if not Steve.is_on_floor():
				Transitioned.emit(self, "idle")
			elif dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")
		elif player_number == 2:
			var dir_x := Input.get_axis("leftp2", "rightp2")
			if not Steve.is_on_floor():
				Transitioned.emit(self, "idle")
			elif dir_x != 0:
				Transitioned.emit(self, "walk")
			else:
				Transitioned.emit(self, "idle")

func exit() -> void:
	kick_timer = 0.0
	cooldown_timer = kick_cooldown
	if hit_box and hit_box.has_method("disable_hitbox"):
		hit_box.disable_hitbox()

func can_kick() -> bool:
	return cooldown_timer <= 0.0

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
		if cooldown_timer < 0:
			cooldown_timer = 0
