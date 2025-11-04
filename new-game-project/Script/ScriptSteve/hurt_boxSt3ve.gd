class_name HurtBox2
extends Area2D

var hit_cooldown := 0.0
var cooldown_duration := 0.2  # Short cooldown between hits

func _ready() -> void:
	collision_layer = 0  # HurtBox2 is not on any layer
	collision_mask = 2   # HurtBox2 checks for layer 2 (HitBox2)
	
	# Connect using Callable
	area_entered.connect(_on_area_entered)
	print("HurtBox2 initialized - listening for HitBox2 on layer 2")

func _process(delta: float) -> void:
	if hit_cooldown > 0:
		hit_cooldown -= delta

func _on_area_entered(area):
	print("DEBUG: Signal fired! Area:", area)
	
	if area == null: 
		print("⚠️ Area entered but it's null")
		return
	
	print("Area details - Name:", area.name, "Script:", area.get_script())
	
	# Check if it's actually a HitBox2
	if area is HitBox2:
		# Only register hit if cooldown is over
		if hit_cooldown <= 0:
			print("💥 Ouch! Hit by:", area.name)
			hit_cooldown = cooldown_duration
		else:
			print("Hit ignored - on cooldown")
	else:
		print("⚠️ Area entered but it's not a HitBox2, it's a:", area.get_class())
