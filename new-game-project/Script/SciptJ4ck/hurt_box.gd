class_name HurtBox
extends Area2D

var hit_cooldown := 0.0
var cooldown_duration := 0.2  # Short cooldown between hits

func _ready() -> void:
	collision_layer = 0  # HurtBox is not on any layer
	collision_mask = 2   # HurtBox checks for layer 2 (HitBox)
	self.area_entered.connect(on_area_entered)
	print("HurtBox initialized - listening for HitBox on layer 2")

func _process(delta: float) -> void:
	if hit_cooldown > 0:
		hit_cooldown -= delta

func on_area_entered(hit_box: HitBox) -> void:
	if hit_box == null: 
		print("⚠️ Area entered but it's null")
		return
	
	# Only register hit if cooldown is over
	if hit_cooldown <= 0:
		print("💥 Ouch! Hit by:", hit_box.name)
		hit_cooldown = cooldown_duration
