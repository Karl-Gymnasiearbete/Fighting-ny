extends State
@export var Steve: CharacterBody2D
var hit_box: Area2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

@export var punch_duration := 0.3
@export var hitbox_active_duration := 0.1
@export var punch_cooldown := 1.0
@export var anim: AnimatedSprite2D

var punch_timer := 0.0
var cooldown_timer := 0.0  # Starts at 0 = ready to punch
var hitbox_disabled := false
var player_number : int = 0
var is_initialized := false  # Track if this state has been set up

func _ready() -> void:
	# Don't run setup until we're actually in the scene tree
	call_deferred("_deferred_ready")

func _deferred_ready() -> void:
	if is_initialized:
		return
	is_initialized = true
	detect_player_number()
		
func detect_player_number() -> void:
	var state_machine = get_parent()
	var character = state_machine.get_parent()
	
	# Check if character has a player_number property set
	if character.has_meta("player_number"):
		player_number = character.get_meta("player_number")
		print("Punch state detected player number: ", player_number)
	else:
		# Fallback: check position in players group
		var all_players = get_tree().get_nodes_in_group("players")
		for i in range(all_players.size()):
			if all_players[i] == character:
				player_number = i + 1
				character.set_meta("player_number", player_number)
				print("Punch state set player number from group: ", player_number)
				break
	
	# Find hitbox when the state is ready
	if Steve:
		hit_box = Steve.find_child("HitBox", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBoxJack", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		
		if hit_box:
			print("✅ Found HitBox in _ready:", hit_box.name)
			if hit_box.has_method("disable_hitbox"):
				hit_box.disable_hitbox()
		else:
			print("⚠️ Could not find HitBox in _ready")

func enter() -> void:
	print("Entered punch - Player ", player_number, " - Cooldown: ", cooldown_timer)
	punch_timer = 0.0
	hitbox_disabled = false
	if anim:
		anim.play("punch")
	
	# Find HitBox node if we don't have it yet
	if not hit_box and Steve:
		hit_box = Steve.find_child("HitBox", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBoxJack", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		
		if hit_box:
			print("✅ Found HitBox:", hit_box.name)
		else:
			print("⚠️ HitBox not found!")
			return
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox when punch starts
	if hit_box and hit_box.has_method("enable_hitbox"):
		print("Enabling hitbox")
		hit_box.enable_hitbox()

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	punch_timer += delta
	
	# Disable hitbox after short duration
	if punch_timer >= hitbox_active_duration and hit_box and not hitbox_disabled:
		if hit_box.has_method("disable_hitbox"):
			hit_box.disable_hitbox()
			hitbox_disabled = true
	
	# Apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
	
	# Exit punch state after animation completes
	if punch_timer >= punch_duration:
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
	print("Exiting punch, setting cooldown to ", punch_cooldown)
	punch_timer = 0.0
	cooldown_timer = punch_cooldown  # Now on cooldown
	if hit_box and hit_box.has_method("disable_hitbox"):
		hit_box.disable_hitbox()

func can_punch() -> bool:
	var can_do = cooldown_timer <= 0.0
	print("can_punch() check - Player ", player_number, " - cooldown: ", cooldown_timer, " - can punch: ", can_do)
	return can_do

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
		# Clamp to avoid negative values
		if cooldown_timer < 0:
			cooldown_timer = 0
