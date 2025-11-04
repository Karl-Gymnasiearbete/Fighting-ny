class_name HitBox2
extends Area2D

@onready var collision_shape = $CollisionShape2D
var is_enabled := false

func _ready():
	# Set collision layers for HitBox2
	collision_layer = 2  # HitBox2 is on layer 2
	collision_mask = 0   # HitBox2 doesn't check for collisions
	
	# Disable hitbox2 by default
	if collision_shape:
		collision_shape.disabled = true
		is_enabled = false
		print("HitBox2 initialized - disabled")
	else:
		print("⚠️ CollisionShape2D not found in HitBox2")

func enable_hitbox2():
	if collision_shape and not is_enabled:
		collision_shape.disabled = false
		is_enabled = true
		print("HitBox2 ENABLED")

func disable_hitbox2():
	if collision_shape and is_enabled:
		collision_shape.disabled = true
		is_enabled = false
		print("HitBox2 DISABLED")
