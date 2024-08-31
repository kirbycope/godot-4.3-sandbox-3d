extends Area2D

# Variable to keep track of whether the player is in the area
var player_in_area = false


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("right") and player_in_area:
		go_up_pipe()


# Function to handle going up the pipe
func go_up_pipe():
	$"../../Player2D".position.x = 2608
	$"../../Player2D".position.y = 167
	$"../../Player2D/Camera2D".limit_top = 0
	$"../../Player2D/Camera2D".limit_right = 10000000
	$"../../Player2D/Camera2D".limit_bottom = 128
	# Play sound effect
	Globals.play_audio("res://assets/sounds/smb/Warp.wav")
	# Play "Overworld" music
	Globals.play_music("res://assets/sounds/smb/Overworld Theme.ogg")
