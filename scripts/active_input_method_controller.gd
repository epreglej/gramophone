extends XROrigin3D

@export var left_joystick_controller: XRController3D
@export var left_hand_controller: XRController3D
@export var left_hand_origin: XRNode3D

func _process(_delta):
	var tracker := XRServer.get_tracker("/user/hand_tracker/left")
	var hand_tracker := tracker as XRHandTracker

	var using_hands: bool = hand_tracker != null and hand_tracker.is_active()
	print(using_hands)

	left_joystick_controller.visible = not using_hands
	left_joystick_controller.process_mode = (
		Node.PROCESS_MODE_DISABLED if using_hands
		else Node.PROCESS_MODE_INHERIT
	)

	left_hand_controller.visible = using_hands
	left_hand_controller.process_mode = (
		Node.PROCESS_MODE_INHERIT if using_hands
		else Node.PROCESS_MODE_DISABLED
	)

	left_hand_controller.visible = using_hands
	left_hand_origin.process_mode = (
		Node.PROCESS_MODE_INHERIT if using_hands
		else Node.PROCESS_MODE_DISABLED
	)
