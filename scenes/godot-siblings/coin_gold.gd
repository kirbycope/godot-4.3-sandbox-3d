extends Node3D

# The speed the coin rotates
var rotation_speed: float = 100.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var rotation_amount = deg_to_rad(rotation_speed) * delta
	rotation.y += rotation_amount


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		# Emit the spark
		$GPUParticles3D.emitting = true
		# Spin the coin faster
		rotation_speed = 500
		# Move the coin
		var tween = get_tree().create_tween()
		tween.tween_property($Model, "position", Vector3(0.0, 0.5, 0.0), 0.8)
		tween.tween_callback(go_away)
		# Wait a moment (for the tween)
		await get_tree().create_timer(0.2).timeout
		# Play sound
		$AudioStreamPlayer3D.play()

func go_away():
	queue_free()
