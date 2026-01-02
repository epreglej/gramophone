@tool
extends XRToolsSnapZone
class_name VinylSnapZone

signal side_changed(side: String)  # "A" or "B"

@export var label: Label3D

func pick_up_object(target: Node3D) -> void:
	if not is_instance_valid(target):
		return

	# --- STEP 1: capture rotation before snapping ---
	var user_up := target.global_transform.basis.y  # vinyl's up before snapping

	# --- STEP 2: call base snap logic (position snapping, highlights, audio) ---
	super.pick_up_object(target)

	if not is_instance_valid(picked_up_object):
		return

	# --- STEP 3: detect which side user left up ---
	var dot := user_up.dot(Vector3.UP)
	var target_side := "A"

	if dot < 0:
		target_side = "B"
		# rotate 180° around axis perpendicular to UP to flip it
		var rotation_axis := user_up.cross(Vector3.UP).normalized()
		if rotation_axis.length_squared() > 0.0:
			picked_up_object.rotate(rotation_axis, PI)
		else:
			# in case user_up is exactly opposite to Vector3.UP
			picked_up_object.rotate(Vector3.RIGHT, PI)

	# --- STEP 4: emit which side is up ---
	side_changed.emit(target_side)
	label.text = target_side
