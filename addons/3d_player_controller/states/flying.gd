extends BaseState

@onready var player: CharacterBody3D = get_parent().get_parent()
var node_name = "Flying"


## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	# Check if the game is not paused
	if !player.game_paused:

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump"):

			# Check if the animation player is not locked
			if !player.is_animation_locked:

				# Check if "jump timer" hasn't started
				if player.timer_jump == 0.0:

					# Set the "jump timer" to the current game time
					player.timer_jump = Time.get_ticks_msec()

				# Check if the "jump timer" is already running
				elif player.timer_jump > 0.0:

					# Get the current game time
					var time_now = Time.get_ticks_msec()

					# Check if _this_ button press is within 200 milliseconds
					if time_now - player.timer_jump < 200:

						# Start "falling"
						transition(node_name, "Falling")

					# Either way, reset the timer
					player.timer_jump = Time.get_ticks_msec()

		# [crouch] button just _pressed_
		if Input.is_action_just_pressed("crouch"):

			# Pitch the player slightly downward
			player.visuals.rotation.x = deg_to_rad(-6)
		
		# [crouch] button currently _pressed_
		if Input.is_action_pressed("crouch"):

			# Decrease the player's vertical position
			player.position.y -= 0.01

			# End animation_flying if collision detected below the player
			if player.raycast_below.is_colliding():

				# Start "standing"
				transition(node_name, "Standing")
		
		# [crouch] button just _released_
		if Input.is_action_just_released("crouch"):

			# Reset the player's pitch
			player.visuals.rotation.x = 0

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump"):
	
			# Pitch the player slightly downward
			player.visuals.rotation.x = deg_to_rad(6)

		# [jump] button currently _pressed_
		if Input.is_action_pressed("jump"):

			# Increase the player's vertical position
			player.position.y += 0.01

		# [jump] button just _released_
		if Input.is_action_just_released("jump"):

			# Reset the player's pitch
				player.visuals.rotation.x = 0

		# Check if the player is "flying"
		if player.is_flying:

			# Play the animation
			play_animation()


## Plays the appropriate animation based on player state.
func play_animation() -> void:

	# Check if the animation player is not locked
	if !player.is_animation_locked:

		# Check if the player is "sprinting"
		if player.is_sprinting:

			# Check if the current animation is not a animation_flying one
			if player.animation_player.current_animation != player.animation_flying_fast:

				# Play the animation_standing "animation_flying Fast" animation
				player.animation_player.play(player.animation_flying_fast)

		# The player must not be "sprinting"
		else:

			# Check if the animation player is not already playing the appropriate animation
			if player.animation_player.current_animation != player.animation_flying:

				# Play the "flying" animation
				player.animation_player.play(player.animation_flying)


## Start "flying".
func start() -> void:

	# Enable _this_ state node
	process_mode = PROCESS_MODE_INHERIT

	# Set the player's new state
	States.current_state = States.State.FLYING

	# Flag the player as "flying"
	player.is_flying = true

	# Set player properties
	player.gravity = 0.0
	player.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
	player.position.y += 0.1
	player.velocity.y = 0.0


## Stop "flying".
func stop() -> void:

	# Disable _this_ state node
	process_mode = PROCESS_MODE_DISABLED

	# Flag the player as not "flying"
	player.is_flying = false

	# [Re]Set player properties
	player.gravity = 9.8
	player.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
	player.velocity.y -= player.gravity
	player.visuals.rotation.x = 0
