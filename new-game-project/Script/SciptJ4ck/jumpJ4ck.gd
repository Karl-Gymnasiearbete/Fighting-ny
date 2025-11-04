extends State
@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var jump_force := 450
@export var air_speed := 400

func enter() -> void:
	print("Entered jump")
	Steve.velocity.y = -jump_force

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("leftArrow", "rightArrow")
	
	# Update punch cooldown
	var punch_state = get_parent().states.get("punch")
	if punch_state:
		punch_state.update_cooldown(delta)
	
	# Punch input (can punch in air, with cooldown check)
	if Input.is_action_just_pressed("punch"):
		if punch_state and punch_state.can_punch():
			Transitioned.emit(self, "punch")
			return
		else:
			print("Punch on cooldown!")
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
