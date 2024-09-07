extends Control

var picks = null
var recommendations = null
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
		var json_as_string = FileAccess.get_file_as_string("res://scenes/main-menu/picks.json")

		# Convert the string to a JSON object
		picks = JSON.parse_string(json_as_string)

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
			var description_path = "Main/Picks/Pick" + str(i) + "/Description"
			# Set the "description" text
			get_node(description_path).text = picks[i].short

			# Connect the button
			var button_path = "Main/Picks/Pick" + str(i) + "/Pick"+ str(i) + "Button"
			var button = get_node(button_path)
			button.pressed.connect(_on_pick_button_pressed.bind(i))

	# Check if the "Recommendations" haven't been populated
	if recommendations == null:

		# Get the "Recommendations" from disk (as a string)
		var json_as_string = FileAccess.get_file_as_string("res://scenes/main-menu/recommendations.json")

		# Convert the string to a JSON object
		recommendations = JSON.parse_string(json_as_string)

		# Iterate over each "Recommendation"
		for i in range(len(recommendations)):

			# Define the "thumbnail" path
			var thumbnail_button_path = "Main/Recommendations/Recommendation" + str(i) + "/Recommendation"+ str(i) + "Button/Thumbnail"
			# Get the "thumbnail" url
			var thumb_url = recommendations[i].thumb
			# Download the "thumbnail" (and apply it)
			download_thumbnail(recommendations[i].pack, thumbnail_button_path, thumb_url)

			# Define the "title" path
			var title_path = "Main/Recommendations/Recommendation" + str(i) + "/Title"
			# Set the "title" text
			get_node(title_path).text = recommendations[i].title

			# Define the "description" path
			var description_path = "Main/Recommendations/Recommendation" + str(i) + "/Description"
			# Set the "description" text
			get_node(description_path).text = recommendations[i].short

			# Connect the button
			var button_path = "Main/Recommendations/Recommendation" + str(i) + "/Recommendation"+ str(i) + "Button"
			var button = get_node(button_path)
			button.pressed.connect(_on_recommendation_button_pressed.bind(i))


## Download resource pack (`.pck`).
func download_pack(pack_name: String, pack_scene: String, pack_url: String):

	# Create a new HTTPRequest node
	var http_request = HTTPRequest.new()

	# Add the node to the scene
	add_child(http_request)

	# Set the response "callback"
	http_request.request_completed.connect(_on_download_pack_completed.bind(pack_name, pack_scene))

	# Initiate the request
	http_request.request(pack_url)


func _on_download_pack_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, pack_name: String, pack_scene: String):

	# Define a path for storing the downloaded .pck file
	var pack_path = "user://" + pack_name + ".pck"
	
	# Save the binary data as a .pck file
	var file = FileAccess.open(pack_path, FileAccess.WRITE)
	file.store_buffer(body)
	file.close()

	# Load the resource pack from the temporary file
	ProjectSettings.load_resource_pack(pack_path)

	# Load the main scene from the resource pack
	Globals.client.load_scene(pack_scene)


## Download and apply thumbnail.
func download_thumbnail(pack_name: String, thumbnail_button_path: String, thumb_url: String):

	# Create a new HTTPRequest node
	var http_request = HTTPRequest.new()

	# Add the node to the scene
	add_child(http_request)

	# Set the response "callback"
	http_request.request_completed.connect(_on_download_thumbnail_completed.bind(pack_name, thumbnail_button_path))

	# Initiate the request
	http_request.request(thumb_url)


func _on_download_thumbnail_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray, pack_name: String, thumbnail_button_path: String):

	# Load the image from the response body
	var image = Image.new()
	image.load_png_from_buffer(body)
	var texture: ImageTexture = ImageTexture.create_from_image(image)

	# Set the "thumbnail" texture
	var thumbnail_button = get_node(thumbnail_button_path)
	thumbnail_button.texture = texture


## Handle the Godot icon button _pressed_.
func _on_godot_engine_button_pressed() -> void:

	# Open the Godot Enging website.
	OS.shell_open("https://godotengine.org/")


## Handle the Pick thumbnail _pressed_.
func _on_pick_button_pressed(index: int):

	# Load the scene
	Globals.client.load_scene(picks[index].scene)


## Handle the Recommendation thumbnail _pressed_.
func _on_recommendation_button_pressed(index: int) -> void:

	# Download the resource pack (`.pck`)
	download_pack(recommendations[index].pack, recommendations[index].scene, recommendations[index].url)
