extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:

	# Check if the collision was triggered by a player
	if body.is_in_group("Player"):

		# Play animation
		$AnimationPlayer.play("bump")

		# Play sound effect
		Globals.play_audio("res://assets/sounds/smb/Bump.wav")
