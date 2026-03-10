class_name HurtBox
extends Area2D

@export var anim: AnimatedSprite2D
var hit_cooldown := 0.0
var cooldown_duration := 0.2

func _ready() -> void:
	collision_layer = 4
	collision_mask = 2
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if hit_cooldown > 0:
		hit_cooldown -= delta

func _on_area_entered(area: Area2D) -> void:
	if hit_cooldown > 0:
		return

	# Get this hurtbox's player number
	var pain = get_parent()
	var hitboxes = pain.get_parent()
	var my_character = hitboxes.get_parent()

	# Get the attacker's player number
	var attacker_character = area.get_parent().get_parent()  # HitBox -> Hitboxes -> CharacterBody2D
	
	# If same character, ignore the hit
	if my_character == attacker_character:
		return

	# rest of your existing code...
	var damage = 1
	var attack_type = "unknown"
	if "damage_amount" in area:
		damage = area.damage_amount
	if "attack_type" in area:
		attack_type = area.attack_type
	hit_cooldown = cooldown_duration
	if my_character.has_meta("is_blocking") and my_character.get_meta("is_blocking"):
		var reduction = my_character.get_meta("damage_reduction")
		var reduced_damage = int(damage * reduction)
		if reduced_damage <= 0:
			return
		damage = reduced_damage
	take_damage(damage, attack_type)

func take_damage(amount: int, attack_type: String) -> void:
	# HealthComponent is a sibling of HurtBox inside Pain
	var health_component = get_parent().find_child("HealthComponent", true, false)

	if health_component and health_component.has_method("damage"):
		health_component.damage(amount, attack_type)
	else:
		print("⚠️ HealthComponent not found! Parent is: ", get_parent().name)
