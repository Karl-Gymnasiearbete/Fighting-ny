class_name PlayerState
extends State

@onready var player: Player = get_tree().get_first_node_in_group("Player")

#Animation Names
var idle_anim: String = "Idle"
var walk_anim: String = "Walk"

#States
@export_group("States")
@export var idle_state: PlayerState
@export var walk_state: PlayerState
   
#Input Keys
var movement_key: String = "Movement"
