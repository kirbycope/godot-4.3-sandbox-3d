extends Control

var picks = null
@onready var username = $Main/Username


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Set the username
	username.text = OS.get_environment("USERNAME")

	# Check if the "Picks" haven't been populated
	if picks == null:
		
		# Get the "Picks" from disk (as a string)
		var json_as_text = FileAccess.get_file_as_string("res://scenes/main-menu/picks.json")
		
		# Convert the string to a JSON object
		picks = JSON.parse_string(json_as_text)
		
		# Iterate over each "Pick"
		for i in range(len(picks)):
			
			# Define the "thumbnail" path
			var texture_path = "Main/Picks/Pick" + str(i) + "/Pick"+ str(i) + "Button/Thumbnail"
			# Set the "thumbnail" texture
			get_node(texture_path).texture = load(picks[i].thumb)
			
			# Define the "title" path
			var title_path = "Main/Picks/Pick" + str(i) + "/Title"
			# Set the "title" text
			get_node(title_path).text = picks[i].title
			
			# Define the "description" path
			var decription_path = "Main/Picks/Pick" + str(i) + "/Description"
			# Set the "description" text
			get_node(decription_path).text = picks[i].short
			
			# Connect the button
			var button_path = "Main/Picks/Pick" + str(i) + "/Pick"+ str(i) + "Button"
			var button = get_node(button_path)
			button.pressed.connect(_on_pick_button_pressed.bind(i))


## Handle the Godot icon button _pressed_.
func _on_godot_engine_button_pressed() -> void:

	# Open the Godot Enging website.
	OS.shell_open("https://godotengine.org/")


## Handle the Pick thumbnail _pressed_.
func _on_pick_button_pressed(index: int):

	# Load the scene
	Globals.client.load_scene(picks[index].scene)
