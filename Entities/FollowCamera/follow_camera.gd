class_name FollowCamera
extends Camera2D

@export var selector: Selector

enum STYLE {Settings, Start, Upgrades}
var style: STYLE

var follow_object: House
var object_pos: Vector2

var std_rotation: float = -5
var std_pos: Vector2 = Vector2(0.0, -16.0)

func _ready() -> void:
	selector.object_selected.connect(on_object_selected)
	selector.object_deselected.connect(on_object_deselected)

func on_object_selected(object: GridObject) -> void:
	object_pos = object.position

func on_object_deselected(object: GridObject) -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	if object_pos != object.position:
		move_camera(object)
	
	await get_tree().create_timer(.3).timeout
	
	object.position = object_pos

func move_camera(object: GridObject) -> void:
	match object.res.name:
		"house_start":
			pass
		"house_menu":
			var tween: Tween = create_tween()
			tween.tween_property(self, "position", Vector2(0, -512) + std_pos, 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
		_:
			pass
