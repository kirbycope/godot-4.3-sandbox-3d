extends CharacterBody2D

var is_jumping: bool = false
var is_high_jumping: bool = false
var timer_jump: float = 0.0

# Note: `@export` variables are available for editing in the property editor.
@export var high_jump_velocity = -300.0
@export var jump_velocity = -240.0
@export var speed = 100.0


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")


## Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
## Use _physics_process(delta) if the input needs to be checked continuously in sync with the physics engine, like for smooth movement or jump control.
func _physics_process(delta: float) -> void:

	# If the game is not paused...
	if !Globals.game_paused:

		# Set animation and velocity based on player action and position
		mangage_state()

		# Handle player movement
		update_velocity(delta)

		# Move player
		move_and_slide()


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Check if the game is paused
	if Globals.game_paused:

		# Get the size of the window
		var screen_size = DisplayServer.window_get_size() * .33

		# Calculate the center of the screen
		var center = screen_size * 0.5

		# Set the position of the pause menu to the center of the screen (instead of the player camera)
		$Camera2D/Pause.position.x = max($"./.."/Player2D.position.x, center.x)
		$Camera2D/Pause.position.y =  center.y - ($Camera2D/Pause.size.y * 0.5)


## Manage the player's state; setting flags and playing animations.
func mangage_state() -> void:

	# Check if player is on a floor
	if is_on_floor():

		# Reset the jumping flags
		is_jumping = false
		is_high_jumping = false

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("crouch"):
			# Set the "jump timer" to the current game time
			timer_jump = Time.get_ticks_msec()
			# Flag the player as "jumping"
			is_jumping = true
			# Set the player's vertical velocity
			velocity.y = jump_velocity
			# Play "jump" sound effect
			Globals.play_audio("res://assets/sounds/smb/Jump.wav")

	# The player is not on a floor
	else:

		# [jump] button currently _pressed_ (and not already "high jumping")
		if Input.is_action_pressed("crouch") and !is_high_jumping:
			# Get the current game time
			var time_now = Time.get_ticks_msec()
			# Check if _this_ button press is within 120 milliseconds
			if time_now - timer_jump > 120:
				# Flag the player as "high jumping"
				is_high_jumping = true
				# Set the player's vertical velocity
				velocity.y = high_jump_velocity

		# [jump] button released
		if Input.is_action_just_released("crouch"):
			is_high_jumping = true


## Update the player's velocity based on input and status.
func update_velocity(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right") # -1 left, 0 middle , 1 right
	if direction:
		velocity.x = direction * speed
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_right")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_right")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		$AnimatedSprite2D.play("default")

	# Check if the player is not on a floor
	if !is_on_floor():
		# Add the gravity
		velocity += get_gravity() * delta
		# Play the "jump" animation
		$AnimatedSprite2D.play("jump_right")
