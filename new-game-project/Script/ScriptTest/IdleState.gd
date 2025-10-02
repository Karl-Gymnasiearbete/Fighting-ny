extends State

@export var Steve: CharacterBody2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func Physics_Update(delta: float) -> void:
	var input_vector := Input.get_vector("left", "right", "up", "down")

	if input_vector != Vector2.ZERO:
		Transitioned.emit(self, "Walk")

	# Gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	else:
		Steve.velocity.y = 0

	Steve.move_and_slide()
