extends Node
## The `Globals` singleton serves to hold variables and functions.
##
## Globals is a singleton, which is a globally accessible object that exists for
## the entire duration of the game. It allows you to store data and functions
## that you want to be available across different scenes and scripts without
## having to pass them around manually.
## @tutorial: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

# Flag for if the app was opened in Debug mode.
var debug_mode:bool = OS.is_debug_build()
