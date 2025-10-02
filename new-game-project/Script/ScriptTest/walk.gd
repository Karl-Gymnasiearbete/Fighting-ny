extends State

@export var Steve: CharacterBody2D
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var speed := 400

func Physics_Update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "", "") # no jump here!

	if direction == Vector2.ZERO:
		Transitioned.emit(self, "Idle")
	else:
		# Keep vertical velocity (Y) for gravity, overwrite only X
		Steve.velocity.x = direction.x * speed

	# Apply gravity
	if not Steve.is_on_floor():
		Steve.velocity.y += gravity * delta
	else:
		Steve.velocity.y = 0

	Steve.move_and_slide()
