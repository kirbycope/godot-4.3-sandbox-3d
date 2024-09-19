extends Node2D

const MAX_DISTANCE := 64
const SWIPE_DEADZONE := 8

var swipe_current_position = null
var swipe_event_index = null
var swipe_delta = null
var swipe_initial_position = null
var tap_event_index = null
var tap_initial_position = null


## Called when CanvasItem has been requested to redraw (after queue_redraw is called, either manually or by the engine).
func _draw() -> void:

	# Check if there is a swipe event
	if swipe_event_index != null:

		# Define the position to draw the gray circle
		var draw_position_gray =  swipe_initial_position

		# Draw a gray circle at the event origin
		draw_circle(draw_position_gray, 64, Color(0.502, 0.502, 0.502, 0.5))

		# Check if for drag motion
		if swipe_current_position != null:

			# Check if the swipe delta is more than the maximum distance
			if swipe_delta.length() > MAX_DISTANCE:

				# Clamp the offset vector's length
				swipe_delta = swipe_delta.normalized() * MAX_DISTANCE

			# Define the position to draw the white circle
			var draw_position_white = swipe_initial_position + swipe_delta

			# Draw a white circle at the event location
			draw_circle(draw_position_white, 48, Color(1.0, 1.0, 1.0, 0.5))


## Called when there is an input event. The input event propagates up through the node tree until a node consumes it.
func _input(event: InputEvent) -> void:

	# Check if the input is a Touch event
	if event is InputEventScreenTouch:

		# [touch] screen just _pressed_
		if event.is_pressed():

			# Check if the touch event took place on the left-half of the screen and the event has not been recorded
			if event.position.x < get_viewport().get_visible_rect().size.x / 2 and !swipe_event_index:

				# Record the touch event index
				swipe_event_index = event.index

				# Record inital position
				swipe_initial_position = event.position

			# The touch event must have took place on the right-half of the screen
			else:

				# Record the touch event index
				tap_event_index = event.index

				# Record inital position
				tap_initial_position = event.position

				# Trigger the [jump] action _pressed_
				Input.action_press("jump")

		# [touch] screen just _released_
		else:

			# Check if the event is related to the swipe event
			if event.index == swipe_event_index:

				# Reset swipe current position
				swipe_current_position = null

				# Reset swipe initial position
				swipe_initial_position = null

				# Reset swipe index
				swipe_event_index = null

				# Trigger the [move_down] action _released_
				Input.action_release("move_down")

				# Trigger the [move_left] action _released_
				Input.action_release("move_left")

				# Trigger the [move_right] action _released_
				Input.action_release("move_right")

				# Trigger the [move_up] action _released_
				Input.action_release("move_up")

			# The touch event must be related to the tap event
			if event.index == tap_event_index:

				# Reset tap position
				tap_initial_position = null

				# Reset tap index
				tap_event_index = null

				# Trigger the [jump] action _released_
				Input.action_release("jump")

	# Check if the input is a Drag event
	if event is InputEventScreenDrag:

		# Check if the event is related to the swipe event
		if event.index == swipe_event_index:

			# Record swipe current position
			swipe_current_position = event.position

			# Calculate the difference between the swipe initial position and the current swipe position
			swipe_delta = swipe_current_position - swipe_initial_position

			# Trigger the [move_left] action _pressed_
			if swipe_delta.x < - SWIPE_DEADZONE:
				Input.action_release("move_right")
				Input.action_press("move_left")

			# Trigger the [move_right] action _pressed_
			if swipe_delta.x > SWIPE_DEADZONE:
				Input.action_release("move_left")
				Input.action_press("move_right")

			# Trigger the [move_up] action _pressed_
			if swipe_delta.y < SWIPE_DEADZONE:
				Input.action_release("move_down")
				Input.action_press("move_up")

			# Trigger the [move_down] action _pressed_
			if swipe_delta.y > SWIPE_DEADZONE:
				Input.action_release("move_up")
				Input.action_press("move_down")

	# Redraw canvas items via `_draw()`
	queue_redraw()


## Called when the node enters the scene tree for the first time.
func _ready() -> void:

	# This CanvasItem will not inherit its transform from parent CanvasItems. 
	top_level = true
