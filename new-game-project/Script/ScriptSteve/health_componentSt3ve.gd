extends Node2D

@export var max_health := 10
var health : int

func _ready() -> void:
	health = max_health
	update_healthbar()

func update_healthbar() -> void:
	# Update the progress bar value
	#$"../ProgressBar".value = health Ta bort # här!!
	# Update the label if you still want text display
	$"../Label".text = str(health) + "hp"

func damage(attack) -> void:
	health -= attack
	health = max(health, 0)  # Prevent negative health
	update_healthbar()
	
	if health <= 0:
		print("Steve Died")
		get_parent().queue_free()
