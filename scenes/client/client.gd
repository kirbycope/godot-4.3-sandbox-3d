extends Node3D

# Scene instance containers
var instance_current = null
var instance_loading = null
var instance_main_menu = null

# Define the resource paths of scenes
const res_loading: String = "res://scenes/loading/loading.tscn"
const res_main_menu: String = "res://scenes/main-menu/main-menu.tscn"

# Preload the scenes into memory
@onready var scene_loading: PackedScene = preload(res_loading)
@onready var scene_main_menu: PackedScene = preload(res_main_menu)


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the object receives a notification, which can be identified in what by comparing it with a constant.
func _notification(what):

	# Check if notifcation is a "close request"
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		
		# [DEBUG] Message
		if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' application closed.")
		
		# Close _this_ application
		get_tree().quit()


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Show the "Main Menu" scene
	scene_main_menu_add()


## Loads the given scene into _this_ one.
func load_scene(path: String) -> void:

	# Hide the main menu
	scene_main_menu_remove()

	# Show the loading screen
	scene_loading_add()

	# Load the scene
	var scene = load(path)

	# Instantiate the scene
	instance_current = scene.instantiate()

	# Add the instance to the current scene
	add_child(instance_current)

	# Hide the loading screen
	scene_loading_remove()


## Add the "Loading" scene to _this_ scene.
func scene_loading_add() -> void:

	# Instantiate the "Loading" scene
	instance_loading = scene_loading.instantiate()

	# Add the instance of the "Loading" scene to the current scene
	add_child(instance_loading)

## Removes the "Loading" scene from _this_ scene.
func scene_loading_remove() -> void:

	# Check for the "Loading" scene
	if instance_loading != null:

		# Remove the instance from the current scene
		instance_loading.queue_free()

		# Reset the instance container
		instance_loading = null


## Adds the "Main Menu" scene to _this_ scene.
func scene_main_menu_add() -> void:

	# Instantiate the "Main Menu" scene
	instance_main_menu = scene_main_menu.instantiate()

	# Add the instance of the "Main Menu" scene to the current scene
	add_child(instance_main_menu)


## Removes the "Main Menu" scene from _this_ scene.
func scene_main_menu_remove() -> void:

	# Check for the "Main Menu" scene
	if instance_main_menu != null:

		# Remove the instance from the current scene
		instance_main_menu.queue_free()

		# Reset the instance container
		instance_main_menu = null


## Removes the "current" scene from _this_ scene.
func unload_scene() -> void:
	
	# Check for the "Current" scene
	if instance_current != null:

		# Show the loading screen
		scene_loading_add()

		# Remove the instance from the current scene
		instance_current.queue_free()

		# Reset the instance container
		instance_current = null

		# Show the "Main Menu" scene
		scene_main_menu_add()

		# Hide the loading screen
		scene_loading_remove()
