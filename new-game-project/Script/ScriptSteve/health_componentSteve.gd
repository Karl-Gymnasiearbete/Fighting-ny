extends Node2D

@export var max_health := 10
var health : int

func _ready() -> void:
	health = max_health
	$"../Label".text = str(health) + "hp"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func damage(attack):
	health -= attack
	$"../Label".text = str(health) + "hp"
	if health <= 0:
		print("Steve Died")
		get_parent().queue_free()
