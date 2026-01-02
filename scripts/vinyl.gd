@tool
extends XRToolsPickable
class_name Vinyl

enum VinylSide { A, B }
var side: VinylSide = VinylSide.A

@onready var snap_pivot: Node3D = $SnapPivot


# Decide which side is up BEFORE snapping
func update_side_before_snapping() -> void:
	# Use world-space up direction
	var vinyl_up: Vector3 = global_transform.basis.y
	var dot := vinyl_up.dot(Vector3.UP)

	side = VinylSide.A if dot > 0.0 else VinylSide.B


# XRTools hook — DO NOT REMOVE
func pick_up(by: Node3D) -> void:
	# 1️⃣ Read orientation BEFORE grab driver exists
	update_side_before_snapping()

	# 2️⃣ Let XRTools create grab driver & snap
	super.pick_up(by)

	# 3️⃣ Apply visual rotation AFTER grab driver is active
	call_deferred("_apply_snap_orientation")


func _apply_snap_orientation() -> void:
	if not is_instance_valid(snap_pivot):
		return

	# Reset first (important if reused)
	snap_pivot.basis = Basis.IDENTITY

	# Flip visually for side B
	if side == VinylSide.B:
		snap_pivot.basis = Basis(Vector3.RIGHT, PI)
