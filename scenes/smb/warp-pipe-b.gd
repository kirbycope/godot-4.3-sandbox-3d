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
	var sfx = load("res://assets/sounds/smb/Warp.wav")
	Globals.main_sound_player.stream = sfx
	Globals.main_sound_player.play()
	# Play "Overworld" music
	var song = load("res://assets/sounds/smb/Overworld Theme.ogg")
	Globals.main_music_player.stream = song
	Globals.main_music_player.play()