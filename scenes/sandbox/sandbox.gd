extends Node3D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Disable the mouse pointer and capture the motion
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


## Called when the node leaves the scene tree.
func _exit_tree() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event) -> void:
	pass


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
