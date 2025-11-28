class_name FollowCamera
extends Camera2D

@export var selector: Selector

enum STYLE {Settings, Start, Upgrades}
var style: STYLE

var follow_object: House
var object_pos: Vector2

@export var std_rotation: float = -5
@export var std_pos: Vector2 = Vector2(0.0, -16.0)
@export var std_zoom: Vector2 = Vector2(5.625, 5.625)

func _ready() -> void:
	if selector:
		selector.object_selected.connect(on_object_selected)
		selector.object_deselected.connect(on_object_deselected)

func on_object_selected(object: GridObject) -> void:
	if not follow_object:
		follow_object = object
		object_pos = object.position

func on_object_deselected(object: GridObject) -> void:
	if object != follow_object:
		return
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	if object_pos != object.position:
		move_camera(object)
	
	await get_tree().create_timer(.25).timeout
	
	object.position = object_pos
	follow_object = null

func move_to_home() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", std_pos, 0.5)
	tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
	tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
	await tween.finished

func move_to_win() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(0.0, 0.0), 4)
	await tween.finished

func move_to_end() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(0, 0.0), 2)
	await tween.finished

func move_camera_game_to_win() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(0.0, 0.0), 0.5)
	tween.parallel().tween_property(self, "rotation", 0, 0.5)
	tween.parallel().tween_property(self, "zoom", Vector2(4.0, 4.0), 0.5)
	await tween.finished

func move_camera_end_to_home() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(640.0, 0), 0.5)
	tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
	await tween.finished
	
	GlobalGameState.state = GlobalGameState.STATES.START

func move_camera_win_to_home() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(640.0, 0), 0.5)
	tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
	await tween.finished
	
	GlobalGameState.state = GlobalGameState.STATES.START

func move_camera(object: GridObject) -> void:
	match object.res.name:
		"house_start":
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			if object.position.x != object_pos.x:
				GlobalVariables.hard_mode = false
				tween.tween_property(self, "position", Vector2(640.0, 0), 0.5)
			elif object.position.y != object_pos.y:
				GlobalVariables.hard_mode = true
				tween.tween_property(self, "position", Vector2(0, 640.0), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
			tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
			await tween.finished
			
			SceneSwitcher.switch_home_to_game()
		"house_settings":
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "position", Vector2(0, -560), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
			MusicManager.switch_music("SHOP")
		"house_upgrades":
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "position", Vector2(0, 528), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
		"house_back":
			var tween: Tween = create_tween()
			tween.set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(self, "position",std_pos, 0.5)
			tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
			tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
			MusicManager.switch_music("START")
		_:
			pass
