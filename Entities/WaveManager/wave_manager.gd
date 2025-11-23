class_name WaveManager
extends Node2D

@export var house_manager: HouseManager
@export var wave_marker_tile_map_layer: WaveMarkerTileMap
@export var sand_tilemap_layer : SandTileMapLayer
@export var game: Game

@export_category("Special Wave Marker")
@export var special_mark_array: Dictionary[int, DIRECTIONS]

@onready var wave_left: WaveSide = $AllWavesLeft
@onready var wave_up: WaveSide = $AllWavesUp
@onready var wave_right: WaveSide = $AllWavesRight
@onready var wave_down: WaveSide = $AllWavesDown

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

signal finished_waves()

func _ready() -> void:
	for wave_side: WaveSide in get_children():
		wave_side.wave_side_finished.connect(on_wave_side_finished)
	wave_left.wave_side_moved.connect(_on_wave_left_moved)
	wave_right.wave_side_moved.connect(_on_wave_right_moved)
	wave_up.wave_side_moved.connect(_on_wave_up_moved)
	wave_down.wave_side_moved.connect(_on_wave_down_moved)

func _on_wave_left_moved(dist: int) -> void:
	var grid_x: int = int(wave_left.global_position.x/GlobalVariables.GRID_SIZE) + dist
	_delet_houses_on_wave(grid_x)

func _on_wave_right_moved(dist: int) -> void:
	var grid_x: int = int(wave_right.global_position.x/GlobalVariables.GRID_SIZE) - dist
	_delet_houses_on_wave(grid_x)

func _on_wave_up_moved(dist: int) -> void:
	var grid_y: int = int(wave_up.global_position.y/GlobalVariables.GRID_SIZE) - dist
	_delet_houses_on_wave(-1000, grid_y)

func _on_wave_down_moved(dist: int) -> void:
	var grid_y: int = int(wave_down.global_position.y/GlobalVariables.GRID_SIZE) + dist
	_delet_houses_on_wave(-1000, grid_y)

func _delet_houses_on_wave(grid_x: int = -1000, grid_y: int = -1000) -> void:
	var danger_cells: Array[Vector2i] = wave_marker_tile_map_layer.get_danger_cells()
	var bound: Vector4i = sand_tilemap_layer.get_grid_bounds()
	
	if grid_x > -1000:
		for y in range(bound.y, bound.w):
			var pos: Vector2i = Vector2i(grid_x, y)
			if not danger_cells.has(pos):
				return
			if house_manager.house_on_pos(pos):
				house_manager.get_house_on_pos(pos).destroy()
		return
	
	for x in range(bound.x, bound.z):
		var pos: Vector2i = Vector2i(x, grid_y)
		if not danger_cells.has(pos):
			return
		if house_manager.house_on_pos(pos):
			house_manager.get_house_on_pos(pos).destroy()

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
	var current_round: int = game.current_round
	if special_mark_array.has(current_round):
		special_state_mark(special_mark_array[current_round])
		special_mark_array.erase(current_round)
	else:
		random_state_mark()

func special_state_mark(dir: DIRECTIONS) -> void:
	depth = 2
	directions = []
	directions.append(dir)
	
	mark_wave.emit()
	state = STATES.SEND
	

func random_state_mark() -> void:
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
	var bounds : Vector4i = sand_tilemap_layer.get_grid_bounds()
	var grid_size : int = GlobalVariables.GRID_SIZE
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
				wave_up.position.y = bounds.w * grid_size - depth * grid_size + 80
				wave_up.start_wave()
				wave_side_count += 1
			DIRECTIONS.RIGHT:
				wave_right.position.x = bounds.z * grid_size - depth * grid_size + 80
				wave_right.start_wave()
				wave_side_count += 1
			DIRECTIONS.UP:
				wave_down.position.y = bounds.y * grid_size + depth * grid_size - 80
				wave_down.start_wave()
				wave_side_count += 1
	
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
