extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] ", "Loading scene added.")


# Called when the node leaves the scene tree.
func _exit_tree():
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] ", "Loading scene removed.")
