extends Node2D

var p1_fight_coll: Array = []   # stores colliders if you need indexing
var disable_coll: bool = true   # track whether colliders are enabled/disabled

func _ready() -> void:
	_handle_all_collider_disabling(disable_coll)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Left"):
		disable_coll = !disable_coll
		_handle_all_collider_disabling(disable_coll)

	if Input.is_action_just_pressed("Down"):
		disable_coll = !disable_coll
		_handle_all_collider_disabling(disable_coll)

# Signals from colliders
func _on_left_hand_body_entered(body: Node2D) -> void:
	pass

func _on_right_hand_body_entered(body: Node2D) -> void:
	pass

func _on_left_foot_body_entered(body: Node2D) -> void:
	pass

func _on_right_foot_body_entered(body: Node2D) -> void:
	pass


# --- Disable ALL colliders in the group ---
func _handle_all_collider_disabling(is_disabled: bool) -> void:
	p1_fight_coll.clear()  # reset the array each time
	
	for collider in get_tree().get_nodes_in_group("P1 hand Feet Coll"):
		p1_fight_coll.append(collider)
		collider.set_disabled(is_disabled)

		# Debug output
		print(collider.name)
		if collider.is_disabled():
			print(collider.name + " is disabled")
		else:
			print(collider.name + " is NOT disabled")
		print("")


# --- Disable a specific collider by index ---
func _handle_specific_collider_disabling(is_disabled: bool, picked_index: int) -> void:
	if picked_index >= 0 and picked_index < p1_fight_coll.size():
		var collider = p1_fight_coll[picked_index]
		collider.set_disabled(is_disabled)

		if collider.is_disabled():
			print(collider.name + " has been DISabled")
		else:
			print(collider.name + " has been enabled")
