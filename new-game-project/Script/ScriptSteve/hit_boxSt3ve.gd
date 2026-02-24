class_name HitBoxSteve
extends Area2D

@export var damage_amount := 1
var attack_type := "punch"
var is_enabled := false

func _ready():
	collision_layer = 2   # Layer 2
	collision_mask = 4    # Detects layer 3 (HurtBoxes)
	
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true
		print("HitBox initialized on ", get_parent().name)

func enable_hitbox():
	if $CollisionShape2D and not is_enabled:
		$CollisionShape2D.disabled = false
		is_enabled = true
		print("HitBox ENABLED on ", get_parent().name)

func disable_hitbox():
	if $CollisionShape2D and is_enabled:
		$CollisionShape2D.disabled = true
		is_enabled = false
		print("HitBox DISABLED")
