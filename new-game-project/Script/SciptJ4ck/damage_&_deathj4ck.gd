extends CharacterBody2D

var health := 10
var dead := false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("damage") and not dead:
		$HealthComponent.damage(1)

func damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()

func die() -> void:
	if dead:
		return
	dead = true
	# Stop movement immediately
	velocity = Vector2.ZERO
	set_physics_process(false)
	queue_free()  # optional
