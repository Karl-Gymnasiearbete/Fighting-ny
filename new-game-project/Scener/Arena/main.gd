extends Node2D

func _ready():
	spawn_player()

func spawn_player():
	var p1_scene = load("res://Character/" + Global.p1_character + ".tscn")
	var player1 = p1_scene.instantiate()
	player1.position = Vector2(200,300)
	add_child(player1)
	
	var p2_scene = load("res://Character/" + Global.p2_character + ".tscn")
	var player2 = p2_scene.instantiate()
	player2.position = Vector2(600,300)
	add_child(player2)
