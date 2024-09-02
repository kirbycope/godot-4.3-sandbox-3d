extends Control


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event) -> void:

	# Check if the [pause] action _pressed_
	if event.is_action_pressed("start"):

		# Toggle game paused
		Globals.game_paused = !Globals.game_paused

		# Show the pause menu, if paused
		visible = Globals.game_paused


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:

	# Toggle mouse capture
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if Globals.game_paused else Input.MOUSE_MODE_CAPTURED)


## Close the pause menu
func _on_back_to_game_button_pressed() -> void:

	# Hide the pause menu
	visible = false

	# Unpause the game
	Globals.game_paused = false


## Handle "Leave Game" button _pressed_.
func _on_leave_game_button_pressed() -> void:

	# Check if this scene was loaded by the $Client
	if Globals.client:

		# Unload _this_ scene
		Globals.client.unload_scene()

	# The scene must have been launched directly
	else:

		# Close "main" scene.
		Globals.main.queue_free()
