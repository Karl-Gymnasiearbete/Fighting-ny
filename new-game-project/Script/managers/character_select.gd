extends Node

var selected_character = ""

func _ready():
	$J4ck.pressed.connect(_on_j4ck_selected)
	$Steve.pressed.connect(_on_steve_selected)

func _on_j4ck_selected():
	selected_character = "J4ck"
	_start_game()

func _on_steve_selected():
	selected_character = "St3ve"
	_start_game()

func _start_game():
	Global.selected_character = selected_character
	get_tree().change_scene_to_file("res://Scener/Arena/main.tscn")
