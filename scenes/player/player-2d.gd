extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -240.0
const HIGH_JUMP_VELOCITY = -280.0

var is_jumping: bool = false
var is_high_jumping: bool = false
var timer_jump: float = 0.0


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# Set the player collision to match "small" Mario
	$CollisionShape2D.shape.size = Vector2($CollisionShape2D.shape.size.x, 16)


## Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
## Use _physics_process(delta) if the input needs to be checked continuously in sync with the physics engine, like for smooth movement or jump control.
func _physics_process(delta: float) -> void:

	# Check if the player is not grounded.
	if not is_on_floor():
		# Add the gravity.
		velocity += get_gravity() * delta

	# Jump if not jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		# Set the "jump timer" to the current game time
		timer_jump = Time.get_ticks_msec()
		# Flag the player as no longer "high jumping"
		is_high_jumping = false
		# Flag the player as "jumping"
		is_jumping = true
		# Set the player's vertical velocity
		velocity.y = JUMP_VELOCITY
	
	# Jump higher is jump button is held
	if Input.is_action_pressed("ui_accept") and !is_on_floor() and !is_high_jumping:
		# Get the current game time
		var time_now = Time.get_ticks_msec()
		# Check if _this_ button press is within 120 milliseconds
		if time_now - timer_jump > 120:
			# Flag the player as "high jumping"
			is_high_jumping = true
			# Set the player's vertical velocity
			velocity.y = HIGH_JUMP_VELOCITY

	# Stop jumping is jump button is released
	if Input.is_action_just_released("ui_accept"):
		is_high_jumping = true

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Move player
	move_and_slide()
