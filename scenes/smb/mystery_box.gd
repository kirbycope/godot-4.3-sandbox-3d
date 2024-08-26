extends AnimatedSprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		# Play sound effect
		var sfx = load("res://assets/sounds/smb/Coin.wav")
		get_parent().get_node("AudioStreamPlayer2D").stream = sfx
		get_parent().get_node("AudioStreamPlayer2D").play()
		# Remove _this_ node from the scene.
		queue_free()
