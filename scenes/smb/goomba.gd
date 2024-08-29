extends AnimatedSprite2D

var player: CharacterBody2D = null
var player_in_bite_area: bool = false
var player_in_stomp_area: bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Check if there is a player collision to process
	if player:
		
		# Check if player is in biting range but not stomping on this Goomba
		if player_in_bite_area and !player_in_stomp_area and player.velocity.y == 0:
			print("Bite!")
		
		# Check if player is stomping on this Goomba and is jumping (ignoring biting range)
		elif player_in_stomp_area and player.velocity.y > 0:
			# Play the "squish" animation
			play("squish")
			# Vault the player off the goomba
			player.velocity.y = -256
			# Wait a moment
			await get_tree().create_timer(0.4)
			# Remove the Goomba after playing the animation
			queue_free()


func _on_bite_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		player_in_bite_area = true


func _on_bite_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
		player_in_bite_area = false


func _on_stomp_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		player_in_stomp_area = true


func _on_stomp_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = null
		player_in_stomp_area = false
