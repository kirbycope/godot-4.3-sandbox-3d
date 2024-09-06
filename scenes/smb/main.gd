extends Node2D

var game_started: bool = false
var players: int = 0
var player_1_coins: int = 0
var player_1_lives: int = 5
var player_1_progress: int = 0
var player_2_coins: int = 0
var player_2_lives: int = 5
var player_2_progress: int = 0


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Disable the mouse pointer and capture the motion
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Make sure the game is unpaused
	Globals.game_paused = false


## Called when there is an input event. The input event propagates up through the node tree until a node consumes it.
func _input(event: InputEvent) -> void:

	# Check if the game is no started
	if !game_started:

		# Check if the input is "start" or [Enter]
		if event.is_action_pressed("start") or (event is InputEventKey and event.pressed and event.keycode == KEY_ENTER):

			# Start the game
			start()


# Start the game, if not started.
func start() -> void:

	# Check if the game has not started
	if !game_started:

		# Clear title screen
		$Title.queue_free()

		# Define next scene to load
		var path = "res://scenes/smb/w1l1.tscn"

		# Load the scene
		var scene = load(path)

		# Instantiate the scene
		var instance_current = scene.instantiate()

		# Add the instance to the current scene
		add_child(instance_current)

		# Flag the game as started
		game_started = true
