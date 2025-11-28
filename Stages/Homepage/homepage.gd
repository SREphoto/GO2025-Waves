class_name Homepage
extends Node2D

@onready var follow_camera: FollowCamera = $FollowCamera

@onready var sunshine: Node2D = $Sunshine

@onready var rock_3: Rock = $ObjectGrid/Rock3

@onready var annotations: Sprite2D = $Annotations

const ANNOTATIONS = preload("uid://sneu0e0u534w")
const ANNOTATIONS_HARD = preload("uid://brax14gvugxgh")

func _ready() -> void:
	if GlobalVariables.first_time:
		follow_camera.rotation = 0
		follow_camera.position = Vector2(-848.0, -25)
		follow_camera.zoom = Vector2(4.0, 4.0)
		await get_tree().create_timer(1).timeout
	else:
		follow_camera.position.x = -384.0
	follow_camera.move_to_home()
	
	var tween: Tween = create_tween()
	tween.tween_property(sunshine, "modulate", Color(1,1,1,1), 0.5)
	
	if GlobalVariables.hard_mode_unlocked:
		annotations.texture = ANNOTATIONS_HARD
		rock_3.queue_free()
	else:
		annotations.texture = ANNOTATIONS
