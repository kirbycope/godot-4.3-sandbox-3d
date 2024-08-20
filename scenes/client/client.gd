extends Node3D

# The "Loading" scene instance
var loading_instance = null
# The resource path of the "Main Menu" scene
var res_main_menu: String = "res://scenes/main-menu/main-menu.tscn"
# The resource path of the "Sandbox" scene
var res_sandbox: String = "res://scenes/sandbox/sandbox.tscn"
# The "Loading" scene
@onready var scene_loading: PackedScene = preload("res://scenes/loading/loading.tscn")
# The local player's name
var username: String = OS.get_environment("USERNAME")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")
	# Load the "Main Menu" scene
	#load_scene(res_main_menu)
	# Load the "Sandbox" scene
	load_scene(res_sandbox)


# Called when the node leaves the scene tree.
func _exit_tree() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), " scene unloaded.")


## Loads the given scene into _this_ one.
func load_scene(path: String) -> void:
	# Show the loading screen
	loading_scene_show()
	# Load the main screen
	var scene = load(path)
	# Instantiate the scene
	var instance = scene.instantiate()
	# Add the instance to the current scene
	add_child(instance)
	# Hide the loading screen
	loading_scene_hide()


## Hides the "Loading" scene.
func loading_scene_hide() -> void:
	# Check for the "Loading" scene
	if loading_instance != null:
		# Remove the instance from the current scene
		loading_instance.queue_free()
		# Reset the instance container
		loading_instance = null


## Shows the "Loading" scene.
func loading_scene_show() -> void:
	# Instantiate the "Loading" scene
	loading_instance = scene_loading.instantiate()
	# Add the instance of the "Loading" scene to the current scene
	add_child(loading_instance)
