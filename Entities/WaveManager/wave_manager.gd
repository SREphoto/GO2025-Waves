class_name WaveManager
extends Node2D

@export var house_manager: HouseManager
@export var wave_marker_tile_map_layer: WaveMarkerTileMap
@export var sand_tilemap_layer : SandTileMapLayer

@onready var wave_left: Node2D = $AllWavesLeft
@onready var wave_up: Node2D = $AllWavesUp
@onready var wave_right: Node2D = $AllWavesRight
@onready var wave_down: Node2D = $AllWavesDown

enum STATES {MARK, SEND}
var state: STATES = STATES.MARK

enum DIRECTIONS {LEFT, UP, RIGHT, DOWN}
var directions: Array[DIRECTIONS]
var last_dir: DIRECTIONS

var depth: int = 2
var radius : int = 32

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
	
	var bounds : Vector4i = sand_tilemap_layer.get_grid_bounds()
	var grid_size : int = GlobalConfigs.GRID_SIZE
	print(bounds)
	# Größter Pfusch aller Zeiten xD

	
	for dir in directions:
		match dir:
			DIRECTIONS.LEFT:
				wave_left.position.x = bounds.x * grid_size + depth * grid_size - 80
				wave_left.start_wave()
			DIRECTIONS.DOWN:
				wave_down.position.y = bounds.y * grid_size + depth * grid_size - 80
				wave_down.start_wave()
			DIRECTIONS.RIGHT:
				wave_right.position.x = bounds.z * grid_size - depth * grid_size + 80
				wave_right.start_wave()
			DIRECTIONS.UP:
				wave_up.position.y = bounds.w * grid_size - depth * grid_size + 80
				wave_up.start_wave()
		await get_tree().create_timer(0.5).timeout
	
	for pos: Vector2i in danger_cells:
		if house_manager.house_on_pos(pos):
			house_manager.get_house_on_pos(pos).destroy()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	send_wave.emit()
