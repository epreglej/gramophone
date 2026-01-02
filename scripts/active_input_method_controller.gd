extends XROrigin3D

@export var left_joystick_controller: XRController3D
@export var left_hand_controller: XRController3D
@export var left_hand_origin: XRNode3D
@export var left_hand_pose_detector: HandPoseDetector

@export var right_joystick_controller: XRController3D
@export var right_hand_controller: XRController3D
@export var right_hand_origin: XRNode3D
@export var right_hand_pose_detector: HandPoseDetector

@export var label: Label3D  # optional debug label

# Debounce timers to smooth initial detection
var left_hand_ready := false
var right_hand_ready := false
var debounce_time := 0.2  # seconds
var left_timer := 0.0
var right_timer := 0.0

func _ready():
	# Connect tracker signals
	XRServer.tracker_added.connect(_on_tracker_changed)
	XRServer.tracker_removed.connect(_on_tracker_changed)
	XRServer.tracker_updated.connect(_on_tracker_changed)

	# Initialize trackers if already present
	if left_hand_pose_detector:
		_on_tracker_changed(left_hand_pose_detector.hand_tracker_name, null)
	if right_hand_pose_detector:
		_on_tracker_changed(right_hand_pose_detector.hand_tracker_name, null)

func _on_tracker_changed(name: StringName, _type):
	# Update left hand tracker
	if left_hand_pose_detector and name == left_hand_pose_detector.hand_tracker_name:
		left_hand_pose_detector.hand_tracker = XRServer.get_tracker(left_hand_pose_detector.hand_tracker_name)
	# Update right hand tracker
	if right_hand_pose_detector and name == right_hand_pose_detector.hand_tracker_name:
		right_hand_pose_detector.hand_tracker = XRServer.get_tracker(right_hand_pose_detector.hand_tracker_name)

func _process(delta):
	var hands_text := ""

	### LEFT HAND ###
	var left_using_hands := false
	if left_hand_pose_detector and left_hand_pose_detector.hand_tracker:
		var left_flags := left_hand_pose_detector.hand_tracker.get_hand_joint_flags(XRHandTracker.HAND_JOINT_PALM)
		if (left_flags & XRHandTracker.HAND_JOINT_FLAG_POSITION_TRACKED != 0) \
		   and (left_flags & XRHandTracker.HAND_JOINT_FLAG_ORIENTATION_TRACKED != 0):
			left_timer += delta
			if left_timer >= debounce_time:
				left_hand_ready = true
		else:
			left_timer = 0.0
			left_hand_ready = false

		left_using_hands = left_hand_ready
	var left_using_controller := not left_using_hands

	# Apply left hand/controller visibility
	left_joystick_controller.visible = left_using_controller
	left_joystick_controller.process_mode = Node.PROCESS_MODE_INHERIT if left_using_controller else Node.PROCESS_MODE_DISABLED

	left_hand_controller.visible = left_using_hands
	left_hand_controller.process_mode = Node.PROCESS_MODE_INHERIT if left_using_hands else Node.PROCESS_MODE_DISABLED

	left_hand_origin.visible = left_using_hands
	left_hand_origin.process_mode = Node.PROCESS_MODE_INHERIT if left_using_hands else Node.PROCESS_MODE_DISABLED

	hands_text += "Left: hands=" + str(left_using_hands) + " controller=" + str(left_using_controller) + "\n"

	### RIGHT HAND ###
	var right_using_hands := false
	if right_hand_pose_detector and right_hand_pose_detector.hand_tracker:
		var right_flags := right_hand_pose_detector.hand_tracker.get_hand_joint_flags(XRHandTracker.HAND_JOINT_PALM)
		if (right_flags & XRHandTracker.HAND_JOINT_FLAG_POSITION_TRACKED != 0) \
		   and (right_flags & XRHandTracker.HAND_JOINT_FLAG_ORIENTATION_TRACKED != 0):
			right_timer += delta
			if right_timer >= debounce_time:
				right_hand_ready = true
		else:
			right_timer = 0.0
			right_hand_ready = false

		right_using_hands = right_hand_ready
	var right_using_controller := not right_using_hands

	# Apply right hand/controller visibility
	right_joystick_controller.visible = right_using_controller
	right_joystick_controller.process_mode = Node.PROCESS_MODE_INHERIT if right_using_controller else Node.PROCESS_MODE_DISABLED

	right_hand_controller.visible = right_using_hands
	right_hand_controller.process_mode = Node.PROCESS_MODE_INHERIT if right_using_hands else Node.PROCESS_MODE_DISABLED

	right_hand_origin.visible = right_using_hands
	right_hand_origin.process_mode = Node.PROCESS_MODE_INHERIT if right_using_hands else Node.PROCESS_MODE_DISABLED

	hands_text += "Right: hands=" + str(right_using_hands) + " controller=" + str(right_using_controller)

	# Update debug label
	if label:
		label.text = hands_text
