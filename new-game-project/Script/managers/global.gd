extends Node

var p1_character = ""
var p2_character = ""
var players_ready = 0

# Call this after character selection, before starting the game
func setup_inputs():
	# Player 1 actions - FIXED: E and C for punch/kick
	remap_action("leftp1", KEY_A)
	remap_action("rightp1", KEY_D)
	remap_action("jumpp1", KEY_W)
	remap_action("crouchp1", KEY_S)
	remap_action("punchp1", KEY_E)  # Changed from I to E
	remap_action("kickp1", KEY_C)   # Changed from M to C
	remap_action("blockp1", KEY_Q)

	
	# Player 2 actions - FIXED: I and M for punch/kick
	remap_action("leftp2", KEY_LEFT)
	remap_action("rightp2", KEY_RIGHT)
	remap_action("jumpp2", KEY_UP)
	remap_action("crouchp2", KEY_DOWN)
	remap_action("punchp2", KEY_I)  # Changed from E to I
	remap_action("kickp2", KEY_M)   # Changed from C to M
	remap_action("blockp2", KEY_U)
	
	print("✅ Inputs configured:")
	print("   Player 1 (", p1_character, ") - WASD + E/C")
	print("   Player 2 (", p2_character, ") - Arrows + I/M")

func remap_action(action_name: String, key_code):
	# Check if action exists first
	if not InputMap.has_action(action_name):
		print("⚠️ Warning: Action '", action_name, "' does not exist in InputMap!")
		return
	
	# Clear existing key events for this action
	InputMap.action_erase_events(action_name)
	
	# Add the new key
	var event = InputEventKey.new()
	event.physical_keycode = key_code
	InputMap.action_add_event(action_name, event)
