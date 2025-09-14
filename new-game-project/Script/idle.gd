class_name PlayerIdleState
extends PlayerState

func enter() -> void:
	super()
	player.animation.play(idle_anim)

func exit() -> void:
	super()
	pass
