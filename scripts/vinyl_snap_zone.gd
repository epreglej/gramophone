@tool
extends XRToolsSnapZone
class_name VinylSnapZone


@export var label: Label3D


var vinyl: Vinyl = null


func pick_up_object(target: Node3D) -> void:
	if not target is Vinyl:
		return
	
	vinyl = target as Vinyl
	
	vinyl.update_side_before_snapping()
	
	super.pick_up_object(target)
	
	_apply_vinyl_rotation()
	
	if label:
		label.text = vinyl.song.title


func _apply_vinyl_rotation() -> void:
	if not is_instance_valid(vinyl):
		return

	var t := vinyl.global_transform

	# Snap zone orientation is the reference
	var base_basis := global_transform.basis

	if vinyl.side == Vinyl.VinylSide.B:
		# Flip 180° around local X (record flipped)
		t.basis = base_basis * Basis(Vector3.RIGHT, PI)
	else:
		# Side A: match snap zone exactly
		t.basis = base_basis

	vinyl.global_transform = t
