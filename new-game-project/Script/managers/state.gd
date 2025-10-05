extends Node
class_name State

signal Transitioned(state, new_state_name)

func enter() -> void:
	pass

func exit() -> void:
	pass

func Update(delta: float) -> void:
	pass

func Physics_Update(delta: float) -> void:
	pass
