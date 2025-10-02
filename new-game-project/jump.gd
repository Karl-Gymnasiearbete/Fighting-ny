extends State

@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
@export var jump_force := 900
@export var air_speed := 400

func enter() -> void:
	Steve.velocity.y = -jump_force
	print("Entered Jump State")

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("left", "right")

	# Horizontal air control
	Steve.velocity.x = dir_x * air_speed

	# Gravity
	Steve.velocity.y += gravity * delta

	Steve.move_and_slide()

	# Landing check
	if Steve.is_on_floor():
		if dir_x == 0:
			Transitioned.emit(self, "Idle")
		else:
			Transitioned.emit(self, "Walk")
