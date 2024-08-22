extends StaticBody3D

# The speed the coin rotates
var rotation_speed: float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation_amount = deg_to_rad(rotation_speed) * delta
	rotation.y += rotation_amount
