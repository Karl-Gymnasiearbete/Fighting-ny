class_name HurtBoxSteve
extends Area2D

var hit_cooldown := 0.0
var cooldown_duration := 0.2

func _ready() -> void:
	collision_layer = 0  # HurtBoxSteve is not on any layer
	collision_mask = 2   # HurtBoxSteve checks for layer 2 (HitBox)
	
	area_entered.connect(_on_area_entered)
	print("HurtBoxSteve initialized - listening for HitBox on layer 2")

func _process(delta: float) -> void:
	if hit_cooldown > 0:
		hit_cooldown -= delta

func _on_area_entered(area: Area2D) -> void:
	if area == null: 
		print("⚠️ Area entered but it's null")
		return
	
	print("HurtBoxSteve detected:", area.name, "on layer:", area.collision_layer)
	
	# Check if it's on layer 2 (HitBox layer)
	if area.collision_layer & 2:
		if hit_cooldown <= 0:
			print("💥 Steve got hit by:", area.name)
			hit_cooldown = cooldown_duration
			take_damage(1)
		else:
			print("Hit ignored - on cooldown")
	else:
		print("⚠️ Area not on HitBox layer")

func take_damage(amount: int) -> void:
	# Navigate up: HurtBoxSteve -> Pain -> CharacterBody2D -> St3ve (Node2D)
	var pain_node = get_parent()
	var character_body = pain_node.get_parent()
	var steve_root = character_body.get_parent()
	
	print("Looking for HealthComponent in:", steve_root.name if steve_root else "null")
	
	var health_component = steve_root.get_node_or_null("HealthComponent")
	
	if not health_component:
		health_component = steve_root.find_child("HealthComponent", true, false)
	
	if health_component and health_component.has_method("damage"):
		health_component.damage(amount)
		print("✅ Steve took", amount, "damage via HealthComponent")
	else:
		print("⚠️ Steve's HealthComponent not found!")
		if steve_root:
			print("Steve's children:")
			for child in steve_root.get_children():
				print("  -", child.name)
