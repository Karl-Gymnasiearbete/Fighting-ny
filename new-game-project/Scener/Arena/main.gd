extends Node2D

var player1
var player2

func _ready():
	spawn_player()

func spawn_player():
	var p1_scene = load("res://Character/" + Global.p1_character + ".tscn")
	player1 = p1_scene.instantiate()  # Assign to the script variable
	player1.position = Vector2(450, 300)
	add_child(player1)
	
	var p2_scene = load("res://Character/" + Global.p2_character + ".tscn")
	player2 = p2_scene.instantiate()  # Assign to the script variable
	player2.position = Vector2(750, 300)
	add_child(player2)
	
	# Make them face each other
	make_characters_face_each_other()

func make_characters_face_each_other():
	# Player 1 faces right (toward player 2)
	player1.scale.x = 1
	
	# Player 2 faces left (toward player 1)
	player2.scale.x = -1
