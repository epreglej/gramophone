@tool
extends XRToolsPickable
class_name Vinyl

const FLIP_THRESHOLD := 0.0  # dot > 0 → SIDE_A, dot < 0 → SIDE_B

enum VinylSide { A, B }

var side: VinylSide = VinylSide.A

var song: AudioStream:
	get:
		return _song_a if side == VinylSide.A else _song_b

@export_group("Side A")
@export var _song_a: AudioStream
@export var _title_a: String = "Unknown Track"
@export var _artist_a: String = "Unknown Artist"

@export_group("Side B")
@export var _song_b: AudioStream
@export var _title_b: String = "Unknown Track B"
@export var _artist_b: String = "Unknown Artist B"

# Update the side based on world rotation
func update_side_before_snapping() -> void:
	var up_vec := global_transform.basis.y
	side = VinylSide.A if up_vec.dot(Vector3.UP) > FLIP_THRESHOLD else VinylSide.B
