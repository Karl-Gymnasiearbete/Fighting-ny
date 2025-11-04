extends State
@export var Steve: CharacterBody2D
@export var anim: AnimatedSprite2D  # Add this line

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var speed := 400

func enter() -> void:
	print("Entered walk")
	if anim:
		anim.play("walk")  # Play walk animation when entering state

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("leftArrow", "rightArrow")
	Steve.velocity.x = dir_x * speed
	
	# Update punch cooldown
	var punch_state = get_parent().states.get("punch")
	if punch_state:
		punch_state.update_cooldown(delta)
	
	# Punch input (check FIRST and cooldown)
	if Input.is_action_just_pressed("punch"):
		if punch_state and punch_state.can_punch():
			Transitioned.emit(self, "punch")
			return
		else:
			print("Punch on cooldown!")
			return
	
	# Jump input
	if Input.is_action_just_pressed("jumpArrow") and Steve.is_on_floor():
		Transitioned.emit(self, "jump")
		return
	
	# Idle transition
	if dir_x == 0:
		Steve.velocity.x = 0
		Transitioned.emit(self, "idle")
		return
	
	# Gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
