extends State
@export var anim: AnimatedSprite2D
@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func enter() -> void:
	Steve.velocity = Vector2.ZERO
	print("Entered idle")
	if anim:
		anim.play("Idle")

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("left", "right")
	
	if not is_instance_valid(Steve) or Steve.dead:
		return #Stops processing if Steve is gone or dead
	
	# Update punch2 cooldown
	var punch2_state = get_parent().states.get("punch2")
	if punch2_state:
		punch2_state.update_cooldown(delta)
	
	# Update kick2 cooldown
	var kick2_state = get_parent().states.get("kick2")
	if kick2_state:
		kick2_state.update_cooldown(delta)
	
	# Punch input (check cooldown)
	if Input.is_action_just_pressed("punch2"):
		if punch2_state and punch2_state.can_punch2():
			Transitioned.emit(self, "punch2")
			return
		else:
			print("Punch on cooldown!")
			return
	
	# Kick input (check cooldown) - FIXED: now checks kick2_state
	if Input.is_action_just_pressed("kick2"):
		if kick2_state and kick2_state.can_kick2():
			Transitioned.emit(self, "kick2")
			return
		else:
			print("Kick on cooldown!")
			return
	
	# Jump input
	if Input.is_action_just_pressed("jump") and Steve.is_on_floor():
		Transitioned.emit(self, "jump")
		return
	
	# Walk transition
	if dir_x != 0:
		Transitioned.emit(self, "walk")
		return
	
	# Gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
