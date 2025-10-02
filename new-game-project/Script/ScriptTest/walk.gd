extends State

@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var speed := 400

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("left", "right")

	# Jump input
	if Input.is_action_just_pressed("jump") and Steve.is_on_floor():
		Transitioned.emit(self, "Jump")
		return

	# Idle transition
	if dir_x == 0:
		Steve.velocity.x = 0
		Transitioned.emit(self, "Idle")
	else:
		Steve.velocity.x = dir_x * speed

	# Gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta

	Steve.move_and_slide()
