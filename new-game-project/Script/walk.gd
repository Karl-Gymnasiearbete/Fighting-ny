class_name WalkState
extends PlayerState

const SPEED: float = 2

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	print("Walk State")

func proces_physics(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	super(delta)
	return null
