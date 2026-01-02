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

func _ready():
	# Connect tracker signals once
	XRServer.tracker_added.connect(_on_tracker_changed)
	XRServer.tracker_removed.connect(_on_tracker_changed)
	
	# Initialize both trackers if already present
	if left_hand_pose_detector:
		_on_tracker_changed(left_hand_pose_detector.hand_tracker_name, null)
	if right_hand_pose_detector:
		_on_tracker_changed(right_hand_pose_detector.hand_tracker_name, null)
	
func _on_tracker_changed(name: StringName, _type):
	# Update left hand tracker dynamically
	if left_hand_pose_detector and name == left_hand_pose_detector.hand_tracker_name:
		left_hand_pose_detector.hand_tracker = XRServer.get_tracker(left_hand_pose_detector.hand_tracker_name)
	# Update right hand tracker dynamically
	if right_hand_pose_detector and name == right_hand_pose_detector.hand_tracker_name:
		right_hand_pose_detector.hand_tracker = XRServer.get_tracker(right_hand_pose_detector.hand_tracker_name)
	
func _process(_delta):
	var hands_text := "No input methods detected."
	
	# Left hand logic
	if left_hand_pose_detector and left_hand_pose_detector.hand_tracker:
		var left_flags := left_hand_pose_detector.hand_tracker.get_hand_joint_flags(XRHandTracker.HAND_JOINT_PALM)
		var left_using_hands := (left_flags & XRHandTracker.HAND_JOINT_FLAG_POSITION_TRACKED != 0) \
			and (left_flags & XRHandTracker.HAND_JOINT_FLAG_ORIENTATION_TRACKED != 0)
		var left_using_controller := not left_using_hands
		
		# Update left controllers
		left_joystick_controller.visible = left_using_controller
		left_joystick_controller.process_mode = (
			Node.PROCESS_MODE_INHERIT if left_using_controller else Node.PROCESS_MODE_DISABLED
		)
		
		left_hand_controller.visible = left_using_hands
		left_hand_controller.process_mode = (
			Node.PROCESS_MODE_INHERIT if left_using_hands else Node.PROCESS_MODE_DISABLED
		)
		
		left_hand_origin.visible = left_using_hands
		left_hand_origin.process_mode = (
			Node.PROCESS_MODE_INHERIT if left_using_hands else Node.PROCESS_MODE_DISABLED
		)
		
		hands_text += "Left: hands=" + str(left_using_hands) + " controller=" + str(left_using_controller) + "\n"
	
	# Right hand logic
	if right_hand_pose_detector and right_hand_pose_detector.hand_tracker:
		var right_flags := right_hand_pose_detector.hand_tracker.get_hand_joint_flags(XRHandTracker.HAND_JOINT_PALM)
		var right_using_hands := (right_flags & XRHandTracker.HAND_JOINT_FLAG_POSITION_TRACKED != 0) \
			and (right_flags & XRHandTracker.HAND_JOINT_FLAG_ORIENTATION_TRACKED != 0)
		var right_using_controller := not right_using_hands
		
		# Update right controllers
		right_joystick_controller.visible = right_using_controller
		right_joystick_controller.process_mode = (
			Node.PROCESS_MODE_INHERIT if right_using_controller else Node.PROCESS_MODE_DISABLED
		)
		
		right_hand_controller.visible = right_using_hands
		right_hand_controller.process_mode = (
			Node.PROCESS_MODE_INHERIT if right_using_hands else Node.PROCESS_MODE_DISABLED
		)
		
		right_hand_origin.visible = right_using_hands
		right_hand_origin.process_mode = (
			Node.PROCESS_MODE_INHERIT if right_using_hands else Node.PROCESS_MODE_DISABLED
		)
		
		hands_text += "Right: hands=" + str(right_using_hands) + " controller=" + str(right_using_controller)
	
	if label:
		label.text = hands_text
