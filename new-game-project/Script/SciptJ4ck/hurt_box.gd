class_name HurtBox
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
	take_damage(damage, attack_type)

func take_damage(amount: int, attack_type: String) -> void:
	# Layout: HurtBox(Pain) -> CharacterBody2D -> Node2D(root)
	# HealthComponent is also inside Pain, so it's a sibling of HurtBox
	var health_component = get_parent().find_child("HealthComponent", true, false)
	
	if health_component and health_component.has_method("damage"):
		health_component.damage(amount, attack_type)
	else:
		print("⚠️ HealthComponent not found! Parent is: ", get_parent().name)
