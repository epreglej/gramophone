@tool
extends XRToolsSnapZone
class_name VinylSnapZone

@export var label: Label3D

var vinyl: Vinyl = null

func pick_up_object(target: Node3D) -> void:
	if not target is Vinyl:
		return
	
	var new_vinyl := target as Vinyl
	
	new_vinyl.update_side_before_snapping()
	
	super.pick_up_object(new_vinyl)
	
	if is_instance_valid(picked_up_object) and picked_up_object is Vinyl:
		vinyl = picked_up_object as Vinyl
		
		if vinyl.side == Vinyl.VinylSide.B:
			vinyl.rotate(Vector3(1,0,0), PI)
	
	if label:
		label.text = str(vinyl.side)
