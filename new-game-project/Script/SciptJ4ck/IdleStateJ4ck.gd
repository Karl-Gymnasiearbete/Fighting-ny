extends State
@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func enter() -> void:
	Steve.velocity = Vector2.ZERO
	print("Entered idle")

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("leftArrow", "rightArrow")
	
	if not is_instance_valid(Steve) or Steve.dead:
		return #Stops processing if Steve is gone or dead
	
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
	
	# Walk transition
	if dir_x != 0:
		Transitioned.emit(self, "walk")
		return
	
	# Gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	
	Steve.move_and_slide()
