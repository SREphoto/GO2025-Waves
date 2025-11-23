class_name Homepage
extends Node2D

@onready var follow_camera: FollowCamera = $FollowCamera

func _ready() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN).tween_property(follow_camera, "offset", Vector2(0,0), 0.25)
