extends Node2D

func _ready():
	spawn_player()

func spawn_player():
	var p1_scene = load("res://Character/" + Global.p1_character + ".tscn")
	var player1 = p1_scene.instantiate()
	player1.postion = Vector2(200,300)
	player1.player_number = 1
	add_child(player1)
	
	var p2_scene = load("res://Character/" + Global.p2_charact + ".tscn")
	var player2 = p2_scene.instantiate()
	player2.postion = Vector2(600,300)
	player2.player_number = 2
	add_child(player1)
