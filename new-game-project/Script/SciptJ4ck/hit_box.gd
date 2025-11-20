class_name HitBox
extends Area2D

@onready var collision_shape = $CollisionShape2D
var is_enabled := false

func _ready():
	# Set collision layers for HitBox
	collision_layer = 2  # HitBox is on layer 2
	collision_mask = 0   # HitBox doesn't check for collisions
	
	# Disable hitbox by default
	if collision_shape:
		collision_shape.disabled = true
		is_enabled = false
		print("HitBox initialized - disabled")
	else:
		print("⚠️ CollisionShape2D not found in HitBox")

func enable_hitbox():
	if collision_shape and not is_enabled:
		collision_shape.disabled = false
		is_enabled = true
		print("HitBox ENABLED")

func disable_hitbox():
	if collision_shape and is_enabled:
		collision_shape.disabled = true
		is_enabled = false
		print("HitBox DISABLED")
