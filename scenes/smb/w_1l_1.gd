extends Node2D


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Play music
	var song = load("res://assets/sounds/smb/Overworld Theme.ogg")
	Globals.main_music_player.stream = song
	Globals.main_music_player.play()
