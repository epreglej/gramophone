extends XROrigin3D

@export var left_joystick_controller: XRController3D
@export var left_hand_controller: XRController3D
@export var left_hand_origin: XRNode3D
@export var label: Label3D

func _process(_delta):
	var tracker = XRServer.get_tracker("/user/hand_tracker/left")
	var using_hands := false

	if tracker:
		# Only use hands if real tracking data is present
		using_hands = tracker.has_tracking_data and tracker.hand_tracking_source == XRHandTracker.HAND_TRACKING_SOURCE_UNOBSTRUCTED

	var using_controller := not using_hands

	# for debug
	print("hands:", using_hands, " controller:", using_controller)
	if label:
		label.text = "hands:" + str(using_hands) + " controller:" + str(using_controller)

	# Controller
	left_joystick_controller.visible = using_controller
	left_joystick_controller.process_mode = (
		Node.PROCESS_MODE_INHERIT if using_controller
		else Node.PROCESS_MODE_DISABLED
	)

	# Hand pose mode
	left_hand_controller.visible = using_hands
	left_hand_controller.process_mode = (
		Node.PROCESS_MODE_INHERIT if using_hands
		else Node.PROCESS_MODE_DISABLED
	)

	left_hand_origin.visible = using_hands
	left_hand_origin.process_mode = (
		Node.PROCESS_MODE_INHERIT if using_hands
		else Node.PROCESS_MODE_DISABLED
	)
