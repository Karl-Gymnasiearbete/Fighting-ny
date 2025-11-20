extends State
@export var Steve: CharacterBody2D
var hit_box: Area2D  # Changed from HitBox to generic Area2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

@export var punch_duration := 0.3
@export var hitbox_active_duration := 0.1
@export var punch_cooldown := 1.0

var punch_timer := 0.0
var cooldown_timer := 0.0
var hitbox_disabled := false

func _ready() -> void:
	# Find hitbox when the state is ready
	if Steve:
		# Try multiple possible names for J4ck's hitbox
		hit_box = Steve.find_child("HitBox", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBoxJack", true, false)
		if not hit_box:
			hit_box = Steve.find_child("HitBox2", true, false)
		
		if hit_box:
			print("✅ Found J4ck's HitBox in _ready:", hit_box.name)
			# Make sure it starts disabled
			if hit_box.has_method("disable_hitbox"):
				hit_box.disable_hitbox()
		else:
			print("⚠️ Could not find HitBox in _ready")

func enter() -> void:
	print("Entered punch (J4ck)")
	punch_timer = 0.0
	hitbox_disabled = false
	
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
			print("⚠️ HitBox not found! Available children:")
			for child in Steve.get_children():
				print("  -", child.name, "(", child.get_class(), ")")
			return
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox when punch starts
	if hit_box and hit_box.has_method("enable_hitbox"):
		print("Enabling J4ck's hitbox")
		hit_box.enable_hitbox()
	else:
		print("⚠️ Cannot enable hitbox - hit_box is null or missing method")

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	punch_timer += delta
	
	# Disable hitbox after short duration (only once)
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
		var dir_x := Input.get_axis("leftArrow", "rightArrow")
		
		if not Steve.is_on_floor():
			Transitioned.emit(self, "idle")
		elif dir_x != 0:
			Transitioned.emit(self, "walk")
		else:
			Transitioned.emit(self, "idle")
		return

func exit() -> void:
	print("Exiting punch (J4ck), disabling hitbox")
	punch_timer = 0.0
	cooldown_timer = punch_cooldown
	if hit_box and hit_box.has_method("disable_hitbox"):
		hit_box.disable_hitbox()

func can_punch() -> bool:
	return cooldown_timer <= 0.0

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
