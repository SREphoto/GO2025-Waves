@tool
class_name CustomTilemap
extends TileMapLayer

@export var grid_size: int = 4:
	set = _set_grid_size

var tile_data_key_array : Array[Vector2i]
var tile_data_dict : Dictionary[Vector2i, int] = {}

var house_idx: int = 0

signal tile_data_changed(pos: Vector2i, data: int)

func _set_grid_size(value) -> void:
	grid_size = value
	_set_tilemap()
	_set_tile_data_dict_value()

func _set_tilemap() -> void:
	clear()
	for row in range(floori(-float(grid_size)/2.0) - 1, floori(float(grid_size)/2.0) + 1):
		for col in range(floori(-float(grid_size)/2.0) - 1, floori(float(grid_size)/2.0) + 1):
			set_cell(Vector2i(row, col), 0, Vector2(0, 0))
	set_cells_terrain_connect(get_used_cells(), 0, 0, false)

func _set_tile_data_dict_value() -> void:
	for row in range(floori(-float(grid_size)/2.0), floori(float(grid_size)/2.0)):
		for col in range(floori(-float(grid_size)/2.0), floori(float(grid_size)/2.0)):
			tile_data_dict.get_or_add(Vector2i(row,col), -1)
	_set_tile_data_key_array()

func _set_tile_data_key_array() -> void:
	tile_data_key_array.clear()
	for key in tile_data_dict.keys():
		tile_data_key_array.append(key)
	tile_data_key_array.shuffle()

func get_tile_data(pos: Vector2):
	var tile_pos = local_to_map(pos)
	if tile_data_dict.has(tile_pos):
		print(tile_data_dict.get(tile_pos))

func set_tile_data(pos: Vector2i, value: int) -> void:
	print(pos)
	if tile_data_dict.has(pos):
		tile_data_dict.set(pos, value)
		tile_data_changed.emit(pos, value)

func _ready() -> void:
	grid_size = grid_size

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		#if Input.is_action_just_pressed("right_click"):
			#get_tile_data(get_global_mouse_position())
		#if Input.is_action_just_pressed("left_click"):
			#set_tile_data(get_global_mouse_position(), not get_tile_data(get_global_mouse_position()))
		if Input.is_action_just_pressed("space"):
			if not tile_data_key_array.is_empty():
				print(tile_data_key_array)
				var rand_tile = tile_data_key_array.pop_back()
				set_tile_data(rand_tile, house_idx + 1)
