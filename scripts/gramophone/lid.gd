extends Node3D
class_name GramophoneLid


signal opened
signal closed


enum Expectation { NONE, OPEN, CLOSE }
var expectation: Expectation = Expectation.NONE
var _is_animation_playing: bool = false


@export var highlight: MeshInstance3D
@export var animation_player: AnimationPlayer
@export var interactable_hinge: XRToolsInteractableHinge
@export var interactable_handle: XRToolsInteractableHandle
@export var tonearm_origin: Node3D


func _ready() -> void:
	interactable_hinge.hinge_moved.connect(_on_hinge_moved)
	
	_set_interactable(false)


func expect_open() -> void:
	expectation = Expectation.OPEN
	set_highlight_color(Color(0,1,0), 1.5)
	_set_interactable(true)


func expect_close() -> void:
	expectation = Expectation.CLOSE
	set_highlight_color(Color(1,0,0), 1.0)
	_set_interactable(true)


func _set_interactable(value: bool) -> void:
	interactable_handle.enabled = value
	highlight.visible = value


func _on_hinge_moved(angle: float) -> void:
	if _is_animation_playing:
		return
	
	match expectation:
		Expectation.OPEN:
			if angle <= -60.0 and angle >= -90.0:
				_is_animation_playing = true
				_set_interactable(false)
				
				animation_player.play("Opening")
				await animation_player.animation_finished
				
				expectation = Expectation.NONE
				_is_animation_playing = false
				opened.emit()
		
		Expectation.CLOSE:
			if angle >= -30.0 and angle <= 0.0:
				_is_animation_playing = true
				_set_interactable(false)
				
				animation_player.play("Closing")
				await animation_player.animation_finished
				
				expectation = Expectation.NONE
				_is_animation_playing = false
				closed.emit()


func set_highlight_color(color: Color, glow_speed: float) -> void:
	#var mat := highlight.get_surface_override_material(0).duplicate()
	var mat := highlight.get_surface_override_material(0)
	
	#highlight.set_surface_override_material(0, mat)
	if mat is ShaderMaterial:
		mat.set_shader_parameter("shell_color", color)
		mat.set_shader_parameter("glow_speed", glow_speed)
