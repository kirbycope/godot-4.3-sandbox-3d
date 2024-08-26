extends Node2D

var is_root: bool = false

## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Get the path of the current scene
	var current_scene_path = self.get_tree().current_scene.get_path().get_concatenated_names()

	# Check if _this_ scene is the root scene
	is_root =  true if current_scene_path == "root/SMB" else false

	# If _this_ is is the root scene, add the player scene to the tree
	if is_root:
		var player_scene = load("res://scenes/player/player-2d.tscn").instantiate()
		player_scene.position.x = 100
		player_scene.position.y = 120
		add_child(player_scene)
