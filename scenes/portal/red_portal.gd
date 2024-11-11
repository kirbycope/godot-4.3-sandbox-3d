extends Node3D

var camera: Camera3D
var mesh_instance: MeshInstance3D
var sub_viewport: SubViewport


func _ready() -> void:
	$MeshInstance3D/SubViewport/Camera3D.current = false

func _process(delta: float) -> void:

	# Check if the camera isn't already set
	if camera == null:

		# Try to get the camera
		camera = $"../BluePortal/MeshInstance3D/SubViewport/Camera3D"

		# If there is a camera
		if camera != null:

			# Ensure the camera renders to the SubViewport
			camera.current = true

			# Get the SubViewPort
			var sub_viewport = $MeshInstance3D/SubViewport

			# Get the texture from the viewport
			var texture = sub_viewport.get_texture()

			# Get the mesh instance
			var mesh_instance = $MeshInstance3D

			# Apply the texture to the MeshInstance3D's material
			if mesh_instance.material_override == null:
				mesh_instance.material_override = StandardMaterial3D.new()

			# Update the material for the mesh instance
			var material = mesh_instance.material_override
			material.albedo_texture = texture
