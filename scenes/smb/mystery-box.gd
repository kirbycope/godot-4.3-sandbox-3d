extends AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:

	# Check if the collision was triggered by a player
	if body.is_in_group("Player"):

		# Play sound effect
		Globals.play_audio("res://assets/sounds/smb/Coin.wav")

		# Remove _this_ node from the scene.
		queue_free()
