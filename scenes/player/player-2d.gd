extends CharacterBody2D

var is_jumping: bool = false
var is_high_jumping: bool = false
var timer_jump: float = 0.0

# Note: `@export` variables are available for editing in the property editor.
@export var SPEED = 100.0
@export var JUMP_VELOCITY = -240.0
@export var HIGH_JUMP_VELOCITY = -300.0


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")

	# Set the player collision to match "small" Mario
	$CollisionShape2D.shape.size = Vector2($CollisionShape2D.shape.size.x, 16)


## Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
## Use _physics_process(delta) if the input needs to be checked continuously in sync with the physics engine, like for smooth movement or jump control.
func _physics_process(delta: float) -> void:

	# Jump if not jumping
	if Input.is_action_just_pressed("crouch") and is_on_floor():
		# Set the "jump timer" to the current game time
		timer_jump = Time.get_ticks_msec()
		# Flag the player as no longer "high jumping"
		is_high_jumping = false
		# Flag the player as "jumping"
		is_jumping = true
		# Set the player's vertical velocity
		velocity.y = JUMP_VELOCITY
		# Play "jump" sound effect
		Globals.play_audio("res://assets/sounds/smb/Jump.wav")
	
	# Jump higher is jump button is held
	if Input.is_action_pressed("crouch") and !is_on_floor() and !is_high_jumping:
		# Get the current game time
		var time_now = Time.get_ticks_msec()
		# Check if _this_ button press is within 120 milliseconds
		if time_now - timer_jump > 120:
			# Flag the player as "high jumping"
			is_high_jumping = true
			# Set the player's vertical velocity
			velocity.y = HIGH_JUMP_VELOCITY

	# Stop jumping is jump button is released
	if Input.is_action_just_released("crouch"):
		is_high_jumping = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right") # -1 left, 0 middle , 1 right
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("walk_right")
		else:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("walk_right")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("default")

	# Check if the player is not on a floor
	if !is_on_floor():
		# Add the gravity
		velocity += get_gravity() * delta
		# Play the "jump" animation
		$AnimatedSprite2D.play("jump_right")

	# Move player
	move_and_slide()
