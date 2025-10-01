extends State

@export var Steve: CharacterBody2D

@export var speed := 400

func Physics_Update(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "jump", "down")

	if direction == Vector2.ZERO:
		Transitioned.emit(self, "Idle")
	else:
		Steve.velocity = direction * speed
		Steve.move_and_slide()
	if Steve.is_on_floor():
		Steve.velocity.y 
