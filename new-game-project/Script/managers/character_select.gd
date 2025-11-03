extends Node

var current_player = 1

func _ready():
	update_prompt()
	$J4ck.pressed.connect(_on_j4ck_selected)
	$Steve.pressed.connect(_on_st3ve_selected)

func update_prompt():
	pass

func _on_j4ck_selected():
	if current_player == 1:
		Global.p1_character = "J4ck"
		current_player = 2
		update_prompt()
	else:
		Global.p2_character = "J4ck"
		_start_game()

func _on_st3ve_selected():
	if current_player == 1:
		Global.p1_character = "St3ve"
		current_player = 2
		update_prompt()
	else:
		Global.p2_character = "St3ve"
		_start_game()

func _start_game():
	get_tree().change_scene_to_file("res://Scener/Arena/main.tscn")
