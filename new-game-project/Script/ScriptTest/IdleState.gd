extends state
class_name idle

@export var enemy: CharacterBody2D

var player : CharacterBody2D

var move_direction : Vector2
var wander_time : float

func enter():
	player = get_tree().get_first_node_in_group("player")

func _Physics_Update():
	var direction = player.global_position - enemy. global_position

if input("left"):
	Transitioned.emit(self, walk)
