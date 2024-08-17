extends Node3D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Disable the mouse pointer and capture the motion
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called when the node leaves the scene tree.
func _exit_tree() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called once for every event before _unhandled_input(), allowing you to consume some events.
## Use _input(event) if you only need to respond to discrete input events, such as detecting a single press or release of a key or button.
func _input(event) -> void:

	# Check if the [pause] action was just _pressed_
	if event.is_action_pressed("start"):
		# Toggle game paused
		Globals.game_paused = !Globals.game_paused
		# Toggle mouse capture
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Globals.game_paused else Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
