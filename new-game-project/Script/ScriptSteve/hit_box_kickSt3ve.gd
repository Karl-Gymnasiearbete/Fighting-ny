class_name HitBoxKickSteve
extends Area2D

@export var damage_amount: int = 2
var attack_type := "kick"
var is_enabled := false

func _ready():
	collision_layer = 2   # Layer 2
	collision_mask = 4    # Detects layer 3 (HurtBoxes)
	
	if $CollisionShape2D:
		$CollisionShape2D.disabled = true
		print("HitBoxKick initialized - damage: ", damage_amount)

func enable_hitbox():
	if $CollisionShape2D and not is_enabled:
		$CollisionShape2D.disabled = false
		is_enabled = true
		print("HitBoxKick ENABLED - damage will be: ", damage_amount)

func disable_hitbox():
	if $CollisionShape2D and is_enabled:
		$CollisionShape2D.disabled = true
		is_enabled = false
		print("HitBoxKick DISABLED")
