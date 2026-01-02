extends XROrigin3D

@onready var left_joystick_controller: XRController3D = $LeftJoystickController
@onready var left_hand_controller: XRController3D = $LeftHandController
@onready var left_hand_origin: XRNode3D = $LeftHandOrigin

func _process(_delta):
	var hand_tracker := XRServer.get_tracker("/user/hand_tracker/left")
	var using_hands: bool = hand_tracker and hand_tracker.is_active()
	
	left_joystick_controller.visible = not using_hands
	left_joystick_controller.process_mode = using_hands \
		if Node.PROCESS_MODE_DISABLED \
		else Node.PROCESS_MODE_INHERIT
	
	left_hand_controller.visible = using_hands
	left_hand_controller.process_mode = using_hands \
		if Node.PROCESS_MODE_INHERIT \
		else Node.PROCESS_MODE_DISABLED
	
	left_hand_origin.process_mode = using_hands \
		if Node.PROCESS_MODE_INHERIT \
		else Node.PROCESS_MODE_DISABLED
