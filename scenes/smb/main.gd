extends Node2D

var game_started: bool = false
var players: int = 0
var player_1_coins: int = 0
var player_1_lives: int = 5
var player_1_progress: int = 0
var player_2_coins: int = 0
var player_2_lives: int = 5
var player_2_progress: int = 0


func _input(event: InputEvent) -> void:
	if !game_started:
		if event.is_action_pressed("start") or (event is InputEventKey and event.pressed and event.keycode == KEY_ENTER):
			start()


func start() -> void:
	print("start!")
	$Title.queue_free()

	# Load W1L1
	var path = "res://scenes/smb/w1l1.tscn"
	# Load the scene
	var scene = load(path)
	
	# Instantiate the scene
	var instance_current = scene.instantiate()

	# Add the instance to the current scene
	add_child(instance_current)

