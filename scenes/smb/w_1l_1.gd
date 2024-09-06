extends Node2D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Add Mario to the scene
	load_mario()

	# Play music
	Globals.play_music("res://assets/sounds/smb/Overworld Theme.ogg")


func load_mario():

	# Define the scene to load
	var path = "res://scenes/player/player-2d.tscn"

	# Load the scene
	var scene = load(path)

	# Instantiate the scene
	var player2d = scene.instantiate()

	# Add the instance to the current scene
	add_child(player2d)
	
	# Add the player group
	player2d.add_to_group("Player")
	
	# Set the collision to match "small" Mario
	var collision_shape = player2d.get_node("CollisionShape2D")
	collision_shape.shape.size = Vector2(collision_shape.shape.size.x, 16)

	# Set initial position
	player2d.position = Vector2(120.00, 199.00)
