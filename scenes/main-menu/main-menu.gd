extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Set the username
	$Main/Username.text = OS.get_environment("USERNAME")


# Called when the node leaves the scene tree.
func _exit_tree() -> void:
	# [DEBUG] Message
	if Globals.debug_mode: print("[DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_godot_engine_button_pressed() -> void:
	OS.shell_open("https://godotengine.org/")


func _on_pick_1_button_pressed() -> void:
	# 0 is Globals (auto-load), 1 is Client
	var client = get_tree().root.get_child(1)
	client.load_scene("res://scenes/sandbox/sandbox.tscn")
