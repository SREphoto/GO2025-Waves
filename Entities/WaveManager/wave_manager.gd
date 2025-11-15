class_name WaveManager
extends Node2D

@export var house_manager: HouseManager
@export var wave_marker_tile_map_layer: WaveMarkerTileMap
@export var sand_tilemap_layer : SandTileMapLayer

@onready var wave_left: Node2D = $AllWavesLeft
@onready var wave_up: Node2D = $AllWavesUp
@onready var wave_right: Node2D = $AllWavesRight
@onready var wave_down: Node2D = $AllWavesDown

enum STATES {MARK, SEND, RUNNING, DONE}
var state: STATES = STATES.MARK

enum DIRECTIONS {LEFT, UP, RIGHT, DOWN}
var directions: Array[DIRECTIONS]
var last_dir: DIRECTIONS

var depth: int = 2
var radius : int = 32

var wave_side_count: int
var wave_side_finished_count: int

signal mark_wave()
signal send_wave()
signal running_wave()

signal finished_waves()

func _ready() -> void:
	for wave_side: WaveSide in get_children():
		wave_side.wave_side_finished.connect(on_wave_side_finished)

func next_state() -> void:
	match state:
			STATES.MARK:
				state_mark()
			STATES.SEND:
				state_send()
			STATES.RUNNING:
				state_running()
			_:
				state = STATES.MARK

func state_mark() -> void:
	var wave_count = randi_range(1, 2)
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
	state = STATES.SEND

func state_send() -> void:
	var danger_cells: Array[Vector2i] = wave_marker_tile_map_layer.get_danger_cells()
	
	var bounds : Vector4i = sand_tilemap_layer.get_grid_bounds()
	var grid_size : int = GlobalConfigs.GRID_SIZE
	# Größter Pfusch aller Zeiten xD

	wave_side_count = 0
	wave_side_finished_count = 0
	
	for dir in directions:
		match dir:
			DIRECTIONS.LEFT:
				wave_left.position.x = bounds.x * grid_size + depth * grid_size - 80
				wave_left.start_wave()
				wave_side_count += 1
			DIRECTIONS.DOWN:
				wave_down.position.y = bounds.y * grid_size + depth * grid_size - 80
				wave_down.start_wave()
				wave_side_count += 1
			DIRECTIONS.RIGHT:
				wave_right.position.x = bounds.z * grid_size - depth * grid_size + 80
				wave_right.start_wave()
				wave_side_count += 1
			DIRECTIONS.UP:
				wave_up.position.y = bounds.w * grid_size - depth * grid_size + 80
				wave_up.start_wave()
				wave_side_count += 1
		#await get_tree().create_timer(0.5).timeout
	
	for pos: Vector2i in danger_cells:
		if house_manager.house_on_pos(pos):
			house_manager.get_house_on_pos(pos).destroy()
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	send_wave.emit()
	state = STATES.RUNNING

func state_running() -> void:
	pass

func on_wave_side_finished() -> void:
	wave_side_finished_count += 1
	if wave_side_finished_count >= wave_side_count:
		_on_waves_finished()

func _on_waves_finished() -> void:
	state = STATES.MARK
	finished_waves.emit()
