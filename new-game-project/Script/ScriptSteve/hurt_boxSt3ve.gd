class_name HurtBoxSteve
extends Area2D

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

	var damage = 1
	var attack_type = "unknown"

	if "damage_amount" in area:
		damage = area.damage_amount
	if "attack_type" in area:
		attack_type = area.attack_type

	hit_cooldown = cooldown_duration

	# Layout: HurtBox -> Pain -> Hitboxes (Node2D) -> CharacterBody2D
	var pain = get_parent()
	var hitboxes = pain.get_parent()
	var character_body = hitboxes.get_parent()

	print("Character body: ", character_body.name, " (", character_body.get_class(), ")")

	if character_body.has_meta("is_blocking") and character_body.get_meta("is_blocking"):
		var reduction = character_body.get_meta("damage_reduction")
		var reduced_damage = int(damage * reduction)
		print("🛡️ Block reduced damage to: ", reduced_damage)
		if reduced_damage <= 0:
			print("🛡️ Attack fully blocked!")
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
