extends Node3D

var camera: Camera3D
var mesh_instance: MeshInstance3D
var material_override: Material
var sub_viewport: SubViewport
var sub_viewport_texture: ViewportTexture


func _ready() -> void:

	# Get the MeshInstance3D
	mesh_instance = $MeshInstance3D

	# Create the MeshInstance3D's material override
	mesh_instance.material_override = StandardMaterial3D.new()
	material_override = mesh_instance.material_override

	# Get the Camera3D
	camera = $"../RedPortal/MeshInstance3D/SubViewport/Camera3D"


func _process(_delta: float) -> void:

	# If there is a camera
	if camera != null:

		# Move the camera (as a child of a SubViewport, it will not move with its parent node)
		camera.global_transform = global_transform
		camera.global_rotation_degrees.y = -camera.global_rotation_degrees.y
		if camera.global_rotation_degrees.y == 0:
			camera.global_rotation_degrees.y = 180

		# Set the texture from the viewport
		material_override.albedo_texture = $MeshInstance3D/SubViewport.get_texture()
