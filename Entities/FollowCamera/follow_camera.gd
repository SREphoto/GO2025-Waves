class_name FollowCamera
extends Camera2D

@export var selector: Selector

enum STYLE {Settings, Start, Upgrades}
var style: STYLE

var follow_object: House
var object_pos: Vector2

var std_rotation: float = deg_to_rad(-5)
var std_pos: Vector2 = Vector2(0.0, -16.0)
var std_zoom: Vector2 = Vector2(5.625, 5.625)

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
	
	await get_tree().create_timer(.25).timeout
	
	object.position = object_pos

func move_camera(object: GridObject) -> void:
	match object.res.name:
		"house_start":
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(self, "position", Vector2(640.0, 0), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
			await tween.finished
			
			SceneSwitcher.switch_home_to_game()
		"house_settings":
			var tween: Tween = create_tween()
			tween.tween_property(self, "position", Vector2(0, -560), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
		"house_upgrades":
			var tween: Tween = create_tween()
			tween.tween_property(self, "position", Vector2(0, 528), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
		"house_back":
			var tween: Tween = create_tween()
			tween.tween_property(self, "position",std_pos, 0.5)
			tween.parallel().tween_property(self, "rotation", std_rotation, 0.5)
			tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
		_:
			pass
