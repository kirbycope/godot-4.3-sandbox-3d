extends CharacterBody3D

var animations_crouching = ["Crawling_InPlace", "Crouching_Idle"]
var animations_flying = ["Flying", "Flying_Fast"]
var animations_hanging = ["Hanging_Idle"]
var animations_jumping = ["Falling_Idle"]
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var is_animation_locked: bool = false
var is_climbing: bool = false
var is_crouching: bool = false
var is_double_jumping: bool = false
var is_flying: bool = false
var is_hanging: bool = false
var is_jumping: bool = false
var is_kicking_left: bool = false
var is_kicking_right: bool = false
var is_punching_left: bool = false
var is_punching_right: bool = false
var is_sprinting: bool = false
var timer_jump: float = 0.0

# Note: `@export` variables are available for editing in the property editor.
@export var enable_double_jump: bool = false
@export var enable_vibration: bool = false
@export var enable_flying: bool = false
@export var force_kicking: float = 2.0
@export var force_kicking_sprinting: float = 3.0
@export var force_punching: float = 1.0
@export var force_punching_sprinting: float = 1.5
@export var force_pushing: float = 1.0
@export var force_pushing_sprinting: float = 2.0
@export var look_sensitivity_controller: float = 120.0
@export var look_sensitivity_mouse: float = 0.2
@export var perspective: int = 0
@export var player_crawling_speed: float = 0.75
@export var player_current_speed: float = 3.0
@export var player_jump_velocity: float = 4.5
@export var player_fast_flying_speed: float = 10.0
@export var player_flying_speed: float = 5.0
@export var player_running_speed: float = 3.5
@export var player_sprinting_speed: float = 5.0
@export var player_walking_speed: float = 1.0

# Note: `@onready` variables are set when the scene is loaded.
@onready var animation_player = $Visuals/AuxScene/AnimationPlayer
@onready var camera_mount = $CameraMount
@onready var camera = $CameraMount/Camera3D
@onready var player_skeleton = $Visuals/AuxScene/Node/Skeleton3D
@onready var pause_menu = $CameraMount/Camera3D/Pause
@onready var raycast_jumptarget = $Visuals/RayCast3D_JumpTarget
@onready var raycast_top = $Visuals/RayCast3D_InFrontPlayer_Top
@onready var raycast_high = $Visuals/RayCast3D_InFrontPlayer_High
@onready var raycast_middle = $Visuals/RayCast3D_InFrontPlayer_Middle
@onready var raycast_low = $Visuals/RayCast3D_InFrontPlayer_Low
@onready var raycast_below = $Visuals/RayCast3D_BelowPlayer
@onready var visuals = $Visuals


## Called once for every event before _unhandled_input(), allowing you to consume some events.
## Use _input(event) if you only need to respond to discrete input events, such as detecting a single press or release of a key or button.
func _input(event) -> void:

	# If the game is not paused...
	if !Globals.game_paused:

		# Check for mouse motion
		if event is InputEventMouseMotion:
			# Rotate camera based on mouse movement
			camera_rotate_by_mouse(event)

		# Check if the animation player is not locked
		if !is_animation_locked:

			# [kick-left] button _pressed_ (while on a floor, but not crouching)
			if event.is_action_pressed("left_kick") and is_on_floor() and !is_crouching:
				# Flag the animation player as locked
				is_animation_locked = true
				# Flag the player as "kicking with their left leg"
				is_kicking_left = true
				# Check if the animation player is not already playing the appropriate animation
				if animation_player.current_animation != "Kicking_Left":
					# Play the left "kicking" animation
					animation_player.play("Kicking_Left")
				# Check the kick hits something
				check_kick_collision()

			# [kick-right] button _pressed_ (while on a floor, but not crouching)
			if event.is_action_pressed("right_kick") and is_on_floor() and !is_crouching:
				# Flag the animation player as locked
				is_animation_locked = true
				# Flag the player as "kicking with their right leg"
				is_kicking_right = true
				# Check if the animation player is not already playing the appropriate animation
				if animation_player.current_animation != "Kicking_Right":
					# Play the right "kicking" animation
					animation_player.play("Kicking_Right")
				# Check the kick hits something
				check_kick_collision()

			# [punch-left] button _pressed_ (while on a floor, but not crouching)
			if event.is_action_pressed("left_punch") and is_on_floor() and !is_crouching:
				# Flag the animation player as locked
				is_animation_locked = true
				# Flag the player as "punching with their left arm"
				is_punching_left = true
				# Check if the player is crouching
				if is_crouching:
					# Check if the animation player is not already playing the appropriate animation
					if animation_player.current_animation != "Punching_Low_Left":
						# Play the left, low "punching" animation
						animation_player.play("Punching_Low_Left")
				# The player should be standing
				else:
					# Check if the animation player is not already playing the appropriate animation
					if animation_player.current_animation != "Punching_Left":
						# Play the left "punching" animation
						animation_player.play("Punching_Left")
				# Check the punch hits something
				check_punch_collision()

			# [punch-right] button _pressed_ (while on a floor, but not crouching)
			if event.is_action_pressed("right_punch") and is_on_floor() and !is_crouching:
				# Flag the animation player as locked
				is_animation_locked = true
				# Flag the player as "punching with their right arm"
				is_punching_right = true
				# Check if the player is crouching
				if is_crouching:
					# Check if the animation player is not already playing the appropriate animation
					if animation_player.current_animation != "Punching_Low_Right":
						# Play the right, low "punching" animation
						animation_player.play("Punching_Low_Right")
				# The player should be standing
				else:
					# Check if the animation player is not already playing the appropriate animation
					if animation_player.current_animation != "Punching_Right":
						# Play the right "punching" animation
						animation_player.play("Punching_Right")
				# Check the punch hits something
				check_punch_collision()

		# [select] button _pressed_
		if event.is_action_pressed("select"):
			if perspective == 0:
				# Flag the player as in "first" person
				perspective = 1
				# Set camera's position
				camera.position = Vector3(0.0, 0.0, 0.0)
				# Align visuals with the camera
				visuals.rotation = Vector3(0.0, 0.0, camera_mount.rotation.z)
				
			# Check if in first-person
			elif perspective == 1:
				# Flag the player as in "third" person
				perspective = 0
				# Set camera mount's position
				camera_mount.position = Vector3(0.0, 1.65, 0.0)
				# Set camera's position
				camera.position = Vector3(0.0, 0.6, 2.5)
				# Set the visual's rotation
				visuals.rotation = Vector3(0.0, 0.0, 0.0)


## Called each physics frame with the time since the last physics frame as argument (delta, in seconds).
## Use _physics_process(delta) if the input needs to be checked continuously in sync with the physics engine, like for smooth movement or jump control.
func _physics_process(delta) -> void:

	# Check if no animation is playing
	if !animation_player.is_playing():
		# Play the idle "Standing" animation
		animation_player.play("Idle")
		# Flag the animation player no longer locked
		is_animation_locked = false
		# Reset player state
		is_kicking_left = false
		is_kicking_right = false
		is_punching_left = false
		is_punching_right = false

	# Set the player's idle animation, as needed
	set_player_idle_animation()

	# If the game is not paused...
	if !Globals.game_paused:

		# set animation and velocity based on player action and position
		mangage_state()

		# Handle [look_*] using controller
		var look_actions = ["look_down", "look_up", "look_left", "look_right"]
		# Check each "look" action in the list
		for action in look_actions:
			# Check if the action is _pressesd_
			if Input.is_action_pressed(action):
				# Rotate camera based on controller movement
				camera_rotate_by_controller(delta)

		# Handle player movement
		update_velocity(delta)

		# Check if the animation player is unlocked
		if !is_animation_locked:
			# Move player
			move_and_slide()

	# Move the camera to player
	move_camera()


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


## Check if the kick hits anything.
func check_kick_collision() -> void:
	# Check if the RayCast3D is collining with something
	if raycast_low.is_colliding():
		# Get the object the RayCast is colliding with
		var collider = raycast_low.get_collider()
		# Get the position of the current collision
		var collision_position = raycast_low.get_collision_point()
		# Delay execution
		await get_tree().create_timer(0.5).timeout
		# Flag the animation player no longer locked
		is_animation_locked = false
		# Reset action flag(s)
		is_kicking_left = false
		is_kicking_right = false
		# Apply force to RigidBody3D objects
		if collider is RigidBody3D:
			# Define the force to apply to the collided object
			var force = force_kicking_sprinting if is_sprinting else force_kicking
			# Define the impulse to apply
			var impulse = collision_position - collider.global_position
			# Apply the force to the object
			collider.apply_central_impulse(-impulse * force)
		# Call character functions
		if collider is CharacterBody3D:
			# Check side
			if is_kicking_left:
				# Play the appropriate hit animation
				if collider.has_method("animate_hit_low_left"):
					collider.call("animate_hit_low_left")
			else:
				# Play the appropriate hit animation
				if collider.has_method("animate_hit_low_right"):
					collider.call("animate_hit_low_right")
		# Controller vibration
		if enable_vibration:
			Input.start_joy_vibration(0, 0.0, 1.0, 0.1)


## Checks if the thrown punch hits anything.
func check_punch_collision() -> void:

	# Check if the RayCast3D is collining with something
	if raycast_middle.is_colliding():
		# Get the object the RayCast is colliding with
		var collider = raycast_middle.get_collider()
		# Get the position of the current collision
		var collision_position = raycast_middle.get_collision_point()
		# Delay execution
		await get_tree().create_timer(0.3).timeout
		# Flag the animation player no longer locked
		is_animation_locked = false
		# Reset action flag(s)
		is_punching_left = false
		is_punching_right = false
		# Apply force to RigidBody3D objects
		if collider is RigidBody3D:
			# Define the force to apply to the collided force_punching
			var force = force_punching_sprinting if is_sprinting else force_punching
			# Define the impulse to apply
			var impulse = collision_position - collider.global_position
			# Apply the force to the object
			collider.apply_central_impulse(-impulse * force)
		# Call character functions
		if collider is CharacterBody3D:
			# Check side
			if is_punching_left:
				# Play the appropriate hit animation
				if collider.has_method("animate_hit_high_left"):
					collider.call("animate_hit_high_left")
			else:
				# Play the appropriate hit animation
				if collider.has_method("animate_hit_high_right"):
					collider.call("animate_hit_high_right")
		# Controller vibration
		if enable_vibration:
			Input.start_joy_vibration(0, 1.0, 0.0, 0.1)


## Check the eyeline for a ledge to grab.
func check_top_edge_collision() -> void:
	if !raycast_top.is_colliding() and raycast_high.is_colliding() and !is_climbing:
		# Check if the current animation is not a "hanging" one
		if animation_player.current_animation != "Hanging_Idle":
			# Play the idle "Hanging" animation
			animation_player.play("Hanging_Idle")
		# Adjust for the animation's player position
		var point = raycast_high.get_collision_point()
		# Determine the direction away from the wall
		var offset_direction = (position - point).normalized()
		# Offset the player by half the width away from the wall
		position = Vector3(point.x + offset_direction.x * 0.2, position.y - 0.45, point.z + offset_direction.z * 0.2)
		# Flag the animation player as locked
		is_animation_locked = true
		# Flag the player as "hanging" (from a ledge)
		is_hanging = true
		# Flag the player as not jumping
		is_jumping = false
		# Reset velocity to prevent any movement
		velocity = Vector3.ZERO
		# Delay execution
		await get_tree().create_timer(0.2).timeout
		# Flag the animation player no longer locked
		is_animation_locked = false


## Rotate camera using the right-analog stick.
func camera_rotate_by_controller(delta: float) -> void:

	# Get the intensity of each action 
	var look_up = Input.get_action_strength("look_up")
	var look_down = Input.get_action_strength("look_down")
	var look_left = Input.get_action_strength("look_left")
	var look_right = Input.get_action_strength("look_right")

	# Calculate the input strength for vertical and horizontal movement
	var vertical_input = look_up - look_down
	var horizontal_input = look_right - look_left
	
	# Adjust rotation speed based on input intensity (magnitude of the right stick movement)
	var vertical_rotation_speed = abs(vertical_input) * look_sensitivity_controller
	var horizontal_rotation_speed = abs(horizontal_input) * look_sensitivity_controller

	# Calculate the desired vertical rotation based on controller motion
	var new_rotation_x = camera_mount.rotation_degrees.x + (vertical_input * vertical_rotation_speed * delta)
	# Limit how far up/down the camera can rotate
	new_rotation_x = clamp(new_rotation_x, -80, 90)
	# Rotate camera up/forward and down/backward
	camera_mount.rotation_degrees.x = new_rotation_x

	# Update the player (visuals+camera) opposite the horizontal controller motion
	rotation_degrees.y = rotation_degrees.y - (horizontal_input * horizontal_rotation_speed * delta)
	# Check if the player is in "third person" perspective
	if perspective == 0:
		# Rotate the visuals opposite the camera's horizontal rotation
		visuals.rotation_degrees.y = visuals.rotation_degrees.y + (horizontal_input * horizontal_rotation_speed * delta)


## Rotate camera using the mouse motion.
func camera_rotate_by_mouse(event: InputEvent) -> void:

	# Calculate the desired vertical rotation based on mouse motion
	var new_rotation_x = camera_mount.rotation_degrees.x - event.relative.y * look_sensitivity_mouse
	# Limit how far up/down the camera can rotate
	new_rotation_x = clamp(new_rotation_x, -80, 90)
	# Rotate camera up/forward and down/backward
	camera_mount.rotation_degrees.x = new_rotation_x
	
	# Update the player (visuals+camera) opposite the horizontal mouse motion
	rotate_y(deg_to_rad(-event.relative.x * look_sensitivity_mouse))
	# Check if the player is in "third person" perspective
	if perspective == 0:
		# Rotate the visuals opposite the camera's horizontal rotation
		visuals.rotate_y(deg_to_rad(event.relative.x * look_sensitivity_mouse))


## Start the player flying.
func flying_start() -> void:
	gravity = 0.0
	motion_mode = MOTION_MODE_FLOATING
	position.y += 0.1
	velocity.y = 0.0
	is_flying = true


## Stop the player flying.
func flying_stop() -> void:
	gravity = 9.8
	motion_mode = MOTION_MODE_GROUNDED
	velocity.y -= gravity
	visuals.rotation.x = 0
	is_flying = false


## Manage the player's state; setting flags and playing animations.
func mangage_state() -> void:

	# [sprint] button _pressed_ (and the animation player is not locked)
	if Input.is_action_pressed("sprint") and !is_animation_locked:
		# Flag the player as "sprinting"
		is_sprinting = true
	
	# [sprint] button just _released_
	if Input.is_action_just_released("sprint"):
		# Flag the player as no longer "sprinting"
		is_sprinting = false
	
	# Check if the player is flying
	if is_flying:

		# [crouch] button just _pressed_
		if Input.is_action_just_pressed("crouch"):
			# Pitch the player slightly downward
			visuals.rotation.x = deg_to_rad(-6)
		
		# [crouch] button currently _pressed_
		if Input.is_action_pressed("crouch"):
			# Decrease the player's vertical position
			position.y -= 0.1
			# End flying if collision detected below the player
			if raycast_below.is_colliding():
				# Stop flying
				flying_stop()
		
		# [crouch] button just _released_
		if Input.is_action_just_released("crouch"):
			# Reset the player's pitch
			visuals.rotation.x = 0

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump"):
			# Pitch the player slightly downward
			visuals.rotation.x = deg_to_rad(6)

		# [jump] button currently _pressed_
		if Input.is_action_pressed("jump"):
			# Increase the player's vertical position
			position.y += 0.1

		# [jump] button just _released_
		if Input.is_action_just_released("jump"):
			# Reset the player's pitch
			visuals.rotation.x = 0

		# [sprint] button _pressed_
		if Input.is_action_pressed("sprint"):
			# Check if the current animation is not a flying one
			if animation_player.current_animation != "Flying_Fast":
				# Play the idle "Flying Fast" animation
				animation_player.play("Flying_Fast")
		else:
			# Check if the current animation is not a flying one
			if animation_player.current_animation not in animations_flying:
				# Play the idle "Flying" animation
				animation_player.play("Flying")

	# Check if the player is hanging (from a ledge)
	if is_hanging:

		# [crouch] button currently _pressed_ (and the animation played is unlocked)
		if Input.is_action_pressed("crouch") and !is_animation_locked:
			# Flag the player as no longer "hanging"
			is_hanging = false
			# Make the player start falling again
			velocity.y = -gravity
			# Play the idle "falling" animation
			animation_player.play("Falling_Idle")

		# [jump] button just _pressed_ (and the animation player is unlocked)
		if Input.is_action_just_pressed("jump") and !is_animation_locked:
			# Flag the player as no longer "hanging"
			is_hanging = false
			# Flag the player as "climbing" (from a ledge)
			is_climbing = true
			# Make the player start falling again
			velocity.y = -gravity
			# Play the idle "Standing" animation
			animation_player.play("Idle")
			# Find the target position
			var collision_point = raycast_jumptarget.get_collision_point()
			# Move the player
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", collision_point, 0.2)
			# Delay execution
			await get_tree().create_timer(0.2).timeout
			# Flag the player as no longer "climbing"
			is_climbing = false


	# Check if player is on a floor
	if is_on_floor():

		# Reset the jumping flags
		is_jumping = false
		is_double_jumping = false

		# [crouch] button currently _pressed_ (and the animation played is unlocked)
		if Input.is_action_pressed("crouch") and !is_animation_locked:
			# Flag the player as "crouching"
			is_crouching = true

		# [crouch] button just _released_
		if Input.is_action_just_released("crouch"):
			# Flag player as no longer "crouching"
			is_crouching = false

		# [jump] button just _pressed_ (and the animation player is unlocked)
		if Input.is_action_just_pressed("jump") and !is_animation_locked:
			# Set the player's vertical velocity
			velocity.y = player_jump_velocity
			# Flag the player as not "double jumping"
			is_double_jumping = false
			# Flag the player as "jumping"
			is_jumping = true
	
	# The player should not be on a floor and not flying
	else:

		# Edge detection
		check_top_edge_collision()
		
		# [crouch] button just _released_
		if Input.is_action_just_released("crouch"):
			# Flag player as no longer "crouching"
			is_crouching = false

		# [jump] button just _pressed_
		if Input.is_action_just_pressed("jump"):

				# Check if "double jump" is enabled and the player is not currently double-jumping
				if enable_double_jump and !is_double_jumping:
					# Set the player's vertical velocity
					velocity.y = player_jump_velocity
					# Set the "double jumping" flag
					is_double_jumping = true

				# Check if "flying" is enabled and the player is not already flying
				if enable_flying and !is_flying:
					# Start flying
					flying_start()

				# Check if "flying" but the "jump timer" hasn't started
				if is_flying and timer_jump == 0.0:
					# Set the "jump timer" to the current game time
					timer_jump = Time.get_ticks_msec()
				# Check if "flying" and the "jump timer" is already running
				elif is_flying and timer_jump > 0.0:
					# Get the current game time
					var time_now = Time.get_ticks_msec()
					# Check if _this_ button press is within 200 milliseconds
					if time_now - timer_jump < 200:
						# Stop flying
						flying_stop()
					# Either way, reset the timer
					timer_jump = Time.get_ticks_msec()


## Update the camera to follow the character head's position (while in "first person").
func move_camera():

	# Check if in "first person" perspective
	if perspective == 1:
		var bone_name = "mixamorigHead"
		var bone_index = player_skeleton.find_bone(bone_name)
		# Get the overall transform of the specified bone, with respect to the player's skeleton.
		var bone_pose = player_skeleton.get_bone_global_pose(bone_index)
		# Adjust the camera mount position to match the bone's relative position (adjusting for $Visuals/AuxScene scaling)
		camera_mount.position = Vector3(-bone_pose.origin.x * 0.01, bone_pose.origin.y * 0.01, (-bone_pose.origin.z * 0.01) - 0.165)


## Sets the player's idle animation based on status.
func set_player_idle_animation() -> void:

	# Check if the player is "crouching"
	if is_crouching:
		# Check if the current animation is not a crouching one
		if animation_player.current_animation not in animations_crouching:
			# Play the idle "Crouching" animation
			animation_player.play("Crouching_Idle")
	# The player should not be crouching
	else:
		# Check if the current animation is still a crouching one
		if animation_player.current_animation in animations_crouching:
			# Play the standing "Idle" animation
			animation_player.play("Idle")
	
	# Check if the player is "flying"
	if is_flying:
		# Check if the current animation is not a flying one
		if animation_player.current_animation not in animations_flying:
			# Play the idle "Flying" animation
			animation_player.play("Flying")
	# The player should not be flying
	else:
		# Check if the current animation is still a flying one
		if animation_player.current_animation in animations_flying:
			# Play the standing "Idle" animation
			animation_player.play("Idle")
	
	# Check if the player is "hanging"
	if is_hanging:
		# Check if the current animation is not a hanging one
		if animation_player.current_animation not in animations_hanging:
			# Play the idle "Hanging" animation
			animation_player.play("Hanging_Idle")
	
	# Check if the player is "jumping"
	if is_jumping:
		# Check if the current animation is not a jumping one
		if animation_player.current_animation not in animations_jumping:
			# Play the idle "Falling" animation
			animation_player.play("Falling_Idle")
	# The player should be "idle"
	else:
		# Check if the current animation is still a jumping one
		if animation_player.current_animation in animations_jumping:
			# Play the standing "Idle" animation
			animation_player.play("Idle")


## Sets the player's movement speed based on status.
func set_player_speed(input_magnitude) -> void:
	# Check if the player is crouching or hanging
	if is_crouching or is_hanging:
		# Set the player's movement speed to the "crawling" speed
		player_current_speed = player_crawling_speed
	# Check if the player is flying and sprinting
	elif is_flying and is_sprinting:
		# Set the player's movement speed to "fast flying"
		player_current_speed = player_fast_flying_speed
	# Check if the player if flying (but not sprinting)
	elif is_flying:
		# Set the player's movement speed to "flying"
		player_current_speed = player_flying_speed
	# Check if the player is sprinting (but not flying)
	elif is_sprinting:
		player_current_speed = player_sprinting_speed
	# The player should be walking (or standing)
	else:
		# Determine player speed based on input magnitude (walking or running)
		player_current_speed = lerp(player_walking_speed, player_running_speed, input_magnitude)


## Update the player's velocity based on input and status.
func update_velocity(delta: float) -> void:

	# Check if the player is not hanging
	if !is_hanging:
		# Add the gravity.
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# Calculate the input magnitude (intensity of the left-analog stick)
	var input_magnitude = input_dir.length()
	
	# Set the player's movement speed
	set_player_speed(input_magnitude)
	
	# Check for directional movement
	if direction:
		# Check if the animation player is unlocked
		if !is_animation_locked:
			# Check if the player is on the ground
			if is_on_floor():
				# Check if the player is crouching
				if is_crouching:
					# Play the crouching "move" animation
					if animation_player.current_animation != "Crawling_InPlace":
						animation_player.play("Crawling_InPlace")
				# Check if the player is sprinting
				elif is_sprinting:
					# Play the sprinting "move" animation
					if animation_player.current_animation != "Sprinting_InPlace":
						animation_player.play("Sprinting_InPlace")
				# The player must be walking or running
				else:
					# Check if the player is running
					if player_current_speed > (player_running_speed - (player_running_speed - player_walking_speed) * 0.25):
						# Play the walking "move" animation
						if animation_player.current_animation != "Running_InPlace":
							animation_player.play("Running_InPlace")
					else:
						# Play the walking "move" animation
						if animation_player.current_animation != "Walking_InPlace":
							animation_player.play("Walking_InPlace")
			# Check if the player is not in "third person" perspective
			if perspective == 0:
				# Update the camera to look in the direction based on player input
				visuals.look_at(position + direction)
			# Update horizontal veolicty
			velocity.x = direction.x * player_current_speed
			# Update vertical veolocity
			velocity.z = direction.z * player_current_speed
	# If no movement detected...
	else:
		# Stop any/all "move" animations
		var animations = ["Crawling_InPlace", "Running_InPlace", "Walking_InPlace"]
		for animation in animations:
			if animation_player.current_animation == animation:
				animation_player.stop()
		# Update horizontal veolicty
		velocity.x = move_toward(velocity.x, 0, player_current_speed)
		# Update vertical veolocity
		velocity.z = move_toward(velocity.z, 0, player_current_speed)