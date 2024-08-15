extends Node3D
## The `client` node serves as the stage for our scenes.
##
## Client is a singleton, which is a globally accessible object that exists for
## the entire duration of the game. It allows you to store data and functions
## that you want to be available across different scenes and scripts without
## having to pass them around manually.
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

# Godot Best Practices
# 1. File names are `kebab-cased`, i.e. `"res://foo-bar.tscn"`.
# 1. Node names are `PascalCased`, i.e. `FooBar`.
# 1. Variable names are `snake_cased`, i.e. `foo_bar += 1`
# 1. Static type variable assignments using `:`.
#	1. Inffered, i.e. `var foo := 1`, (less compile time, more runtime).
#	1. Explicit, i.e. `var bar:int = 1`, (more compile time, less runtime).
# 1. Double-space before function declarations/comments.
# 1. Double-hash before function comments.
# 1. Single-space to seperate steps in a function.
# 1. Single-hash before code comments.
# 1. Arrange functions and variables alphabetically.
# 1. Use prefixes to group variables, i.e. `player_postion` and `player_health`.

# The "Loading" scene instance
var loading_instance = null
# The resource path of the "Main Menu" scene
var res_main_menu:String = "res://scenes/main-menu/main-menu.tscn"

# Note: `@onready` variables are set when the scene is loaded.

# The "Loading" scene.
@onready var scene_loading:PackedScene = preload("res://scenes/loading/loading.tscn")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.debug_mode: print("[DEBUG] ","Client scene loaded.")
	# Load the "Main Menu" scene
	load_scene(res_main_menu)


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass # Replace with function body.


## Loads the given scene into _this_ one.
func load_scene(path:String) -> void:
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
