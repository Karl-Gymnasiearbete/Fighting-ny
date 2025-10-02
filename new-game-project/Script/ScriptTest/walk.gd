extends State

@export var Steve: CharacterBody2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 400

func Physics_Update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "", "")

	if direction == Vector2.ZERO:
		# Stop moving when no input
		Steve.velocity.x = 0
		Transitioned.emit(self, "Idle")
	else:
		# Update horizontal movement
		Steve.velocity.x = direction.x * speed

	# Gravity (always applied)
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	else:
		Steve.velocity.y = 0

	Steve.move_and_slide()
