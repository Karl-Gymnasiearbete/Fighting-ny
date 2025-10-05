extends State

@export var Steve: CharacterBody2D
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

func enter() -> void:
	Steve.velocity = Vector2.ZERO
	print("Entered idle")

func Physics_Update(delta: float) -> void:
	var dir_x := Input.get_axis("leftArrow", "rightArrow")

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
