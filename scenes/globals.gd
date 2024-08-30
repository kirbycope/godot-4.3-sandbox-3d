extends Node
## The `Globals` singleton serves to hold variables and functions.
##
## Globals is a singleton, which is a globally accessible object that exists for
## the entire duration of the game. It allows you to store data and functions
## that you want to be available across different scenes and scripts without
## having to pass them around manually.
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

# The Client scene.
var client:
	get:
		var children = get_tree().root.get_children()
		for child in children:
			if child.get_path().get_concatenated_names() == "root/Client":
				return child

# Flag for if the app was opened in Debug mode.
var debug_mode: bool = OS.is_debug_build()

# Flag for if the game is Paused.
var game_paused: bool = false

# The "main" scene's _music_ AudioPlayer channel.
var main_music_player:
	get:
		return client.get_node("Main").get_node("Music")

# The "main" scene's _sound_ AudioPlayer channel.
var main_sound_player:
	get:
		return client.get_node("Main").get_node("Sound")

# The current time in RFC 3339 format.
var time_stamp_utc: bool = true
var time_stamp: String:
	get:
		var return_value = Time.get_datetime_string_from_system(time_stamp_utc)
		return return_value + "Z" if time_stamp_utc else return_value
