extends State
@export var Steve: CharacterBody2D
var hit_box2: HitBox2
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var punch2_duration := 0.3
@export var hitbox2_active_duration := 0.1  # hitbox2 only active for this long
@export var punch2_cooldown := 1.0  # Cooldown before can punch2 again
var punch2_timer := 0.0
var cooldown_timer := 0.0
var hitbox2_disabled := false  # Track if we've already disabled the hitbox2

func _ready() -> void:
	# Find hitbox2 when the state is ready
	if Steve:
		hit_box2 = Steve.find_child("hitbox2", true, false)
		if hit_box2:
			print("✅ Found hitbox2 in _ready:", hit_box2)
		else:
			print("⚠️ Could not find hitbox2 in _ready")

func enter() -> void:
	print("Entered punch2")
	punch2_timer = 0.0
	hitbox2_disabled = false  # Reset flag
	
	# Try to find hitbox2 if we don't have it yet
	if not hit_box2 and Steve:
		hit_box2 = Steve.find_child("hitbox2", true, false)
		if hit_box2:
			print("✅ Found hitbox2 in enter:", hit_box2)
		else:
			print("⚠️ Could not find hitbox2 - check node name!")
			# Print Steve's children to debug
			print("Steve's children:", Steve.get_children())
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox2 when punch2 starts
	if hit_box2:
		print("Enabling hitbox2")
		hit_box2.enable_hitbox2()
	else:
		print("⚠️ hit_box2 is null, cannot enable!")

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	punch2_timer += delta
	
	# Disable hitbox2 after short duration (only once)
	if punch2_timer >= hitbox2_active_duration and hit_box2 and not hitbox2_disabled:
		hit_box2.disable_hitbox2()
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
	print("Exiting punch2, disabling hitbox2")
	punch2_timer = 0.0
	cooldown_timer = punch2_cooldown  # Start cooldown
	if hit_box2:
		hit_box2.disable_hitbox2()

func can_punch2() -> bool:
	return cooldown_timer <= 0.0

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
