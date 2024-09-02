extends Node2D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Set the player collision to match "small" Mario
	$Player2D/CollisionShape2D.shape.size = Vector2($Player2D/CollisionShape2D.shape.size.x, 16)

	# Play music
	Globals.play_music("res://assets/sounds/smb/Overworld Theme.ogg")
