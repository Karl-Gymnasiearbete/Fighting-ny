extends Node

#för att använda hitstop skriv HitStopManager.hitStop()

#freeze frames för hits
func hitStop():
	Engine.time_scale = 0
	await get_tree().create_timer(0.15, true, false, true).timeout
	Engine.time_scale = 1 
