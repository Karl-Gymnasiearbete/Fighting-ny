extends State
@export var Steve: CharacterBody2D
var hit_box: HitBox
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var punch_duration := 0.3
@export var hitbox_active_duration := 0.1  # HitBox only active for this long
@export var punch_cooldown := 1.0  # Cooldown before can punch again
var punch_timer := 0.0
var cooldown_timer := 0.0
var hitbox_disabled := false  # Track if we've already disabled the hitbox

func enter() -> void:
	print("Entered punch")
	punch_timer = 0.0
	hitbox_disabled = false  # Reset flag
	
	if not hit_box and Steve:
		hit_box = Steve.find_child("HitBox", true, false)
		if hit_box:
			print("✅ Found HitBox:", hit_box)
	
	if Steve:
		Steve.velocity.x = 0
	
	# Enable the hitbox when punch starts
	if hit_box:
		print("Enabling hitbox")
		hit_box.enable_hitbox()

func Physics_Update(delta: float) -> void:
	if not Steve:
		return
	
	punch_timer += delta
	
	# Disable hitbox after short duration (only once)
	if punch_timer >= hitbox_active_duration and hit_box and not hitbox_disabled:
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
	print("Exiting punch, disabling hitbox")
	punch_timer = 0.0
	cooldown_timer = punch_cooldown  # Start cooldown
	if hit_box:
		hit_box.disable_hitbox()

func can_punch() -> bool:
	return cooldown_timer <= 0.0

func update_cooldown(delta: float) -> void:
	if cooldown_timer > 0:
		cooldown_timer -= delta
