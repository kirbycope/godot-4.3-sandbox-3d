extends Control

var last_input_device: String = ""
@onready var stick_l_origin: Vector2 = $XboxController/White/StickL.position
@onready var stick_r_origin: Vector2 = $XboxController/White/StickR.position


## Called when the node leaves the scene tree.
func _exit_tree() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene unloaded.")


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# [DEBUG] Message
	if Globals.debug_mode: print(Globals.time_stamp, " [DEBUG] '", get_script().resource_path.get_file().get_basename(), "' scene loaded.")


## Called once for every event before _unhandled_input(), allowing you to consume some events.
func _input(event) -> void:

	# [debug] button _pressed_
	if event.is_action_pressed("debug"):
		
		# Toggle "debug" visibility
		visible = !visible

	# Check if the Debug UI is currently displayed
	if visible:

		# Check if the current Input Event was triggered by a keyboard
		if event is InputEventKey or event is InputEventMouse or event is InputEventMouseMotion:

			# Flag the last input device
			last_input_device = "Keyboard"

		# Check if the current Input Event was triggered by a joypad
		if event is InputEventJoypadButton or event is InputEventJoypadMotion:

			# Flag the last input device
			last_input_device = "Controller"

			# Get the joypad's name
			var device_name = Input.get_joy_name(event.device)

			# Check if the joypad is an XBox controller
			if device_name == "XInput Gamepad":

				# ⍐ (D-Pad Up)
				if event.is_action_pressed("dpad_up"):
					$XboxController/White/DPadUp.visible = false
				elif event.is_action_released("dpad_up"):
					$XboxController/White/DPadUp.visible = true
				# ⍗ (D-Pad Down)
				if event.is_action_pressed("dpad_down"):
					$XboxController/White/DPadDown.visible = false
				elif event.is_action_released("dpad_down"):
					$XboxController/White/DPadDown.visible = true
				# ⍇ (D-Pad Left)
				if event.is_action_pressed("dpad_left"):
					$XboxController/White/DPadLeft.visible = false
				elif event.is_action_released("dpad_left"):
					$XboxController/White/DPadLeft.visible = true
				# ⍈ (D-Pad Right)
				if event.is_action_pressed("dpad_right"):
					$XboxController/White/DPadRight.visible = false
				elif event.is_action_released("dpad_right"):
					$XboxController/White/DPadRight.visible = true
				# Ⓐ
				if event.is_action_pressed("crouch"):
					$XboxController/White/ButtonA.visible = false
				elif event.is_action_released("crouch"):
					$XboxController/White/ButtonA.visible = true
				# Ⓑ
				if event.is_action_pressed("sprint"):
					$XboxController/White/ButtonB.visible = false
				elif event.is_action_released("sprint"):
					$XboxController/White/ButtonB.visible = true
				# Ⓧ
				if event.is_action_pressed("use"):
					$XboxController/White/ButtonX.visible = false
				elif event.is_action_released("use"):
					$XboxController/White/ButtonX.visible = true
				# Ⓨ
				if event.is_action_pressed("jump"):
					$XboxController/White/ButtonY.visible = false
				elif event.is_action_released("jump"):
					$XboxController/White/ButtonY.visible = true
				# ☰ (Start)
				if event.is_action_pressed("start"):
					$XboxController/White/ButtonStart.visible = false
				elif event.is_action_released("start"):
					$XboxController/White/ButtonStart.visible = true
				# ⧉ (Select)
				if event.is_action_pressed("select"):
					$XboxController/White/ButtonSelect.visible = false
				elif event.is_action_released("select"):
					$XboxController/White/ButtonSelect.visible = true
				# Ⓛ1 (L1)
				if event.is_action_pressed("left_punch"):
					$XboxController/White/ButtonL1.visible = false
				elif event.is_action_released("left_punch"):
					$XboxController/White/ButtonL1.visible = true
				# Ⓛ2 (L2)
				if event.is_action_pressed("left_kick"):
					$XboxController/White/ButtonL2.visible = false
				elif event.is_action_released("left_kick"):
					$XboxController/White/ButtonL2.visible = true
				# Ⓡ1 (R1)
				if event.is_action_pressed("right_punch"):
					$XboxController/White/ButtonR1.visible = false
				elif event.is_action_released("right_punch"):
					$XboxController/White/ButtonR1.visible = true
				# Ⓡ2 (R2)
				if event.is_action_pressed("right_kick"):
					$XboxController/White/ButtonR2.visible = false
				elif event.is_action_released("right_kick"):
					$XboxController/White/ButtonR2.visible = true


## Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:

	# Check is the Debug Panel is visible
	if visible:

		# Panel
		$Panel/CheckBox1.button_pressed = $"../../..".enable_double_jump
		$Panel/CheckBox2.button_pressed = $"../../..".enable_flying
		$Panel/CheckBox3.button_pressed = $"../../..".enable_vibration
		$Panel/CheckBox4.button_pressed = $"../../..".is_animation_locked
		$Panel/CheckBox5.button_pressed = $"../../..".is_crouching
		$Panel/CheckBox6.button_pressed = $"../../..".is_double_jumping
		$Panel/CheckBox7.button_pressed = $"../../..".is_flying
		$Panel/CheckBox8.button_pressed = $"../../..".is_hanging
		$Panel/CheckBox9.button_pressed = $"../../..".is_jumping
		$Panel/CheckBox10.button_pressed = $"../../..".is_kicking_left
		$Panel/CheckBox11.button_pressed = $"../../..".is_kicking_right
		$Panel/CheckBox12.button_pressed = $"../../..".is_punching_left
		$Panel/CheckBox13.button_pressed = $"../../..".is_punching_right
		$Panel/CheckBox14.button_pressed = $"../../..".is_sprinting
		$Panel/CheckBox15.button_pressed = Globals.game_paused

		if last_input_device == "Controller":

			# Get Left-stick magnitude
			var left_stick_input = Vector2(
				Input.get_axis("left", "right"),
				Input.get_axis("forward", "backward")
			)

			# Apply position based on left-stick magnitude
			if left_stick_input.length() > 0:
				# Move StickL based on stick input strength
				$XboxController/White/StickL.position = stick_l_origin + left_stick_input * 10.0
			else:
				# Return StickL to its original position when stick is released
				$XboxController/White/StickL.position = stick_l_origin

			# Get right-stick magnitude
			var right_stick_input = Vector2(
				Input.get_axis("look_left", "look_right"),
				Input.get_axis("look_up", "look_down")
			)

			# Apply position based on right-stick magnitude
			if right_stick_input.length() > 0:
				# Move StickR based on stick input strength
				$XboxController/White/StickR.position = stick_r_origin + right_stick_input * 10.0
			else:
				# Return StickR to its original position when stick is released
				$XboxController/White/StickR.position = stick_r_origin
