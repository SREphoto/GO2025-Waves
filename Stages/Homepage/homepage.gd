class_name Homepage
extends Node2D

@onready var follow_camera: FollowCamera = $FollowCamera

func _ready() -> void:
	if GlobalVariables.first_time:
		follow_camera.rotation = 0
		follow_camera.position = Vector2(-848.0, -25)
		follow_camera.zoom = Vector2(4.0, 4.0)
		await get_tree().create_timer(1).timeout
	else:
		follow_camera.position.x = -384.0
	follow_camera.move_to_home()
