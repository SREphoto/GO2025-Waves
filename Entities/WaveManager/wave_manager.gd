class_name WaveManager
extends Node2D

@export var house_manager: HouseManager
@export var wave_marker_tile_map_layer: WaveMarkerTileMap

enum STATES {MARK, SEND}
var state: STATES = STATES.MARK

enum DIRECTIONS {LEFT, UP, RIGHT, DOWN}
var directions: Array[DIRECTIONS]
var last_dir: DIRECTIONS

var depth: int = 2

signal mark_wave()
signal send_wave()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.waves):
		match state:
			STATES.MARK:
				state_mark()
				state = STATES.SEND
			STATES.SEND:
				state_send()
				state = STATES.MARK
			_:
				state = STATES.MARK

func state_mark() -> void:
	var wave_count = randi_range(1, 3)
	if wave_count > 1:
		depth = 1
	else:
		depth = 2
	directions = []
	for i in wave_count:
		var dir = randi_range(0, DIRECTIONS.size() - 1) as DIRECTIONS
		while directions.has(dir):
			dir = randi_range(0, DIRECTIONS.size() - 1) as DIRECTIONS
		directions.append(dir)
		if i == 0:
			while directions[0] == last_dir:
				directions[0] = randi_range(0, DIRECTIONS.size() - 1) as DIRECTIONS
			last_dir = directions[0]
	
	mark_wave.emit()
	

func state_send() -> void:
	var danger_cells: Array[Vector2i] = wave_marker_tile_map_layer.get_danger_cells()
	for pos: Vector2i in danger_cells:
		if house_manager.house_on_pos(pos):
			house_manager.get_house_on_pos(pos).destroy()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	send_wave.emit()
