extends Node2D

func _ready():
	spawn_player()

func spawn_player():
	var character_scene
	
	if Global.selected_character == "J4ck":
		character_scene = load("res://Character/j4ck.tscn")
	elif Global.selected_character == "St3ve":
		character_scene = load("res://Character/st3ve.tscn")
	
	var player = character_scene.instantiate()
	add_child(player)
