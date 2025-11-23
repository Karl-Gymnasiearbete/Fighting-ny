extends State

@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var jump_force := 450
@export var air_speed := 400

func enter() -> void:
	print("Entered jump")
	Steve.velocity.y = -jump_force

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("left", "right")
	
	# Update punch2 cooldown
	var punch2_state = get_parent().states.get("punch2")
	if punch2_state:
		punch2_state.update_cooldown(delta)
	
	# Update kick2 cooldown
	var kick2_state = get_parent().states.get("kick2")
	if kick2_state:
		kick2_state.update_cooldown(delta)
	
	# Punch input (can punch in air, with cooldown check)
	if Input.is_action_just_pressed("punch2"):
		if punch2_state and punch2_state.can_punch2():
			Transitioned.emit(self, "punch2")
			return
		else:
			print("Punch on cooldown!")
			return
	
	# Kick input (can kick in air, with cooldown check) - FIXED
	if Input.is_action_just_pressed("kick2"):
		if kick2_state and kick2_state.can_kick2():
			Transitioned.emit(self, "kick2")
			return
		else:
			print("Kick on cooldown!")
			return
	
	# Horizontal air control
	Steve.velocity.x = dir_x * air_speed
	
	# Gravity
	Steve.velocity.y += gravity * delta
	
	# Apply motion
	Steve.move_and_slide()
	
	# Landing check
	if Steve.is_on_floor():
		if dir_x == 0:
			Transitioned.emit(self, "idle")
		else:
			Transitioned.emit(self, "walk")
