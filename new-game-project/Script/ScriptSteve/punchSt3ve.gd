extends State
@export var Steve: CharacterBody2D
var hit_box: Area2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

@export var punch2_duration := 0.3
@export var hitbox2_active_duration := 0.1
@export var punch2_cooldown := 1.0

var punch2_timer := 0.0
var cooldown_timer := 0.0
var hitbox2_disabled := false

func _ready() -> void:
	# Find hitbox when the state is ready - prioritize HitBoxSteve
	if Steve:
		# Try Steve-specific names first
		hit_box = Steve.find_child("HitBoxSteve", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox", true, false)
		
		if hit_box:
			print("✅ Found Steve's HitBox in _ready:", hit_box.name)
			# Make sure it starts disabled
			if hit_box.has_method("disable_hitbox"):
				hit_box.disable_hitbox()
		else:
			print("⚠️ Could not find HitBox in _ready")

func enter() -> void:
	print("Entered punch2 (Steve)")
	punch2_timer = 0.0
	hitbox2_disabled = false
	
	# Try to find hitbox if we don't have it yet - prioritize HitBoxSteve
	if not hit_box and Steve:
		hit_box = Steve.find_child("HitBoxSteve", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox", true, false)
		
		if hit_box:
			print("✅ Found Steve's HitBox in enter:", hit_box.name)
		else:
			print("⚠️ Could not find HitBox - check node name!")
			print("Steve's children:")
			for child in Steve.get_children():
				print("  -", child.name, "(", child.get_class(), ")")
			return
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox when punch starts
	if hit_box and hit_box.has_method("enable_hitbox"):
		print("Enabling Steve's hitbox")
		hit_box.enable_hitbox()
	else:
		print("⚠️ hit_box is null or missing enable_hitbox method!")

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	punch2_timer += delta
	
	# Disable hitbox after short duration (only once)
	if punch2_timer >= hitbox2_active_duration and hit_box and not hitbox2_disabled:
		if hit_box.has_method("disable_hitbox"):
			hit_box.disable_hitbox()
			hitbox2_disabled = true
	
	# Apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
	
	# Exit punch2 state after animation completes
	if punch2_timer >= punch2_duration:
		var dir_x := Input.get_axis("left", "right")
		
		if not Steve.is_on_floor():
			Transitioned.emit(self, "idle")
		elif dir_x != 0:
			Transitioned.emit(self, "walk")
		else:
			Transitioned.emit(self, "idle")
		return

func exit() -> void:
	print("Exiting punch2 (Steve), disabling hitbox")
	punch2_timer = 0.0
	cooldown_timer = punch2_cooldown
	if hit_box and hit_box.has_method("disable_hitbox"):
		hit_box.disable_hitbox()

func can_punch2() -> bool:
	return cooldown_timer <= 0.0

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
