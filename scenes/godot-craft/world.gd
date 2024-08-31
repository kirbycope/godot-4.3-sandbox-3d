extends Node3D


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Disable the mouse pointer and capture the motion
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Make sure the game is unpaused
	Globals.game_paused = false

	# Put the player in first-person perspective
	$Player.perspective = 1

	# Set camera's position
	$Player/CameraMount/Camera3D.position = Vector3(0.0, 0.0, 0.0)

	# Align visuals with the camera
	$Player/Visuals.rotation = Vector3(0.0, 0.0, $Player/CameraMount.rotation.z)
