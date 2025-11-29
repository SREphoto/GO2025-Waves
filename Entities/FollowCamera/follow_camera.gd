class_name FollowCamera
extends Camera2D

@export var selector: Selector

enum STYLE {Settings, Start, Upgrades}
var style: STYLE

@export var std_rotation: float = -5
@export var std_pos: Vector2 = Vector2(0.0, -16.0)
@export var std_zoom: Vector2 = Vector2(5.625, 5.625)

var locked: bool = false

func object_moved(object: House, dir: Vector2i) -> void:
	if locked:
		return
	locked = true
	var object_pos = object.position
	var switch_scene = false
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	match dir:
		Vector2i.UP:
			tween.tween_property(self, "position", Vector2(0, -560), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
			MusicManager.switch_music("SHOP")
		Vector2i.DOWN:
			match object.res.name:
				"house_start":
					GlobalVariables.hard_mode = true
					tween.tween_property(self, "position", Vector2(0, 640.0), 0.5)
					tween.parallel().tween_property(self, "rotation", 0, 0.5)
					tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
					switch_scene = true
				"house_back":
					tween.tween_property(self, "position",std_pos, 0.5)
					tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
					tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
					MusicManager.switch_music("START")
		Vector2i.RIGHT:
			GlobalVariables.hard_mode = false
			tween.tween_property(self, "position", Vector2(640.0, 0), 0.5)
			tween.parallel().tween_property(self, "rotation", 0, 0.5)
			tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
			switch_scene = true
		_:
			pass
	
	await get_tree().create_timer(0.25).timeout
	object.position = object_pos
	await tween.finished
	locked = false
	if switch_scene:
		SceneSwitcher.switch_home_to_game()

func move_to_home() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", std_pos, 0.5)
	tween.parallel().tween_property(self, "rotation", deg_to_rad(std_rotation), 0.5)
	tween.parallel().tween_property(self, "zoom", std_zoom, 0.5)
	await tween.finished

func move_to_win() -> void:
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(0.0, 0.0), 3.5)
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
