extends CharacterBody2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		# Play animation
		$AnimationPlayer.play("bump")
		# Play sound effect
		var sfx = load("res://assets/sounds/smb/Bump.wav")
		Globals.main_sound_player.stream = sfx
		Globals.main_sound_player.play()
