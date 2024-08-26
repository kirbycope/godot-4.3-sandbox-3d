extends Control

@onready var username = $Main/Username


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Set the username
	username.text = OS.get_environment("USERNAME")


## Handle the Godot icon button _pressed_.
func _on_godot_engine_button_pressed() -> void:

	# Open the Godot Enging website.
	OS.shell_open("https://godotengine.org/")


## Handle Pick 1 button _pressed_.
func _on_pick_1_button_pressed() -> void:

	# Load the "Sandbox" scene
	Globals.client.load_scene("res://scenes/sandbox/sandbox.tscn")


## Handle Pick 2 button _pressed_.
func _on_pick_2_button_pressed() -> void:

	# Load the "World" scene
	Globals.client.load_scene("res://scenes/godot-craft/world.tscn")


## Handle Pick 3 button _pressed_.
func _on_pick_3_button_pressed() -> void:
	
	# Load the "Super Mario Bros." scene
	Globals.client.load_scene("res://scenes/smb/smb.tscn")
