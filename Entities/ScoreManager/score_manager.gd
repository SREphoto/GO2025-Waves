class_name ScoreManager
extends Node2D

@export var sand_tile_map_layer : SandTileMapLayer
@export var house_manager : HouseManager
@export var wave_manager: WaveManager

var house_grid: Dictionary[Vector2i, House]
var multi_house_grid: Dictionary[Vector2i, House]
var color_groups: Array[Array] = []
var biggest_color_groups: Array[Array] = []:
	set(value):
		biggest_color_groups = value
		biggest_color_groups_changed.emit()

var multi_changed_houses: Dictionary[House, Array] = {}

signal score_changed()

signal biggest_color_groups_changed()

func _ready() -> void:
	house_manager.house_spawned.connect(on_house_spawned)
	wave_manager.mark_wave.connect(on_wave_marked)
	wave_manager.send_wave.connect(on_wave_sent)

func on_house_spawned(_house: House) -> void:
	score()

func on_wave_marked() -> void:
	score()

func on_wave_sent() -> void:
	score()

func on_object_move_finished() -> void:
	score()

func score():
	house_grid = house_manager.get_houses_on_grid()
	multi_house_grid = house_manager.get_multi_houses_on_grid(house_grid)
	#_apply_multis(multi_house_grid)
	_apply_tile_multis(multi_house_grid)
	color_groups = _group_houses_by_color(house_grid)
	set_flag_values()
	biggest_color_groups = _get_biggest_color_groups()
	set_flag_modulate()
	score_changed.emit()

#Not used
func _clear_multis(multi_house_dict:Dictionary) -> void:
	for pos in multi_house_dict.keys():
		var house: House = multi_house_dict[pos]
		house.current_points = house.standard_points
#Not used
func _apply_multis(multi_house_dict: Dictionary[Vector2i, House]) -> void:
	_clear_multis(multi_house_dict)
	for pos in multi_house_dict.keys():
		var house: House = multi_house_dict[pos]
		if house.in_danger:
			continue
			
		match house.res.name:
			"house_multi_around":
				var neighbors = [
						pos + Vector2i(1, -1),  # up-right
						pos + Vector2i(1, 0),   # right
						pos + Vector2i(1, 1),	# down-right
						pos + Vector2i(0, 1),   # down
						pos + Vector2i(-1, 1),  # down-left
						pos + Vector2i(-1, 0),  # left
						pos + Vector2i(-1, -1),  # left-up
						pos + Vector2i(0, -1)   # up
					]
				for neighbor_pos in neighbors:
					if not multi_house_dict.has(neighbor_pos):
						continue
					var neighbor_house: House = multi_house_dict[neighbor_pos]
					neighbor_house.current_points = neighbor_house.current_points * house.standard_points
			"house_multi_minus":
				var bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
				for x_pos in range(bounds.x, bounds.z):
					var current_pos: Vector2i = Vector2i(x_pos, pos.y)
					if not multi_house_dict.has(current_pos) or pos == current_pos:
						continue
					var current_house: House = multi_house_dict[current_pos]
					current_house.current_points = current_house.current_points * house.standard_points
			"house_multi_plus":
				var bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
				for x_pos in range(bounds.x, bounds.z):
					var current_pos: Vector2i = Vector2i(x_pos, pos.y)
					if not multi_house_dict.has(current_pos) or pos == current_pos:
						continue
					var current_house: House = multi_house_dict[current_pos]
					current_house.current_points = current_house.current_points * house.standard_points
				for y_pos in range(bounds.y, bounds.w):
					var current_pos: Vector2i = Vector2i(pos.x, y_pos)
					if not multi_house_dict.has(current_pos) or pos == current_pos:
						continue
					var current_house: House = multi_house_dict[current_pos]
					current_house.current_points = current_house.current_points * house.standard_points

func _clear_tile_multis(house_dict:Dictionary) -> void:
	for pos in house_dict.keys():
		var house: House = house_dict[pos]
		if house.multi_house:
			continue
		house.current_points = house.standard_points

func _apply_tile_multis(multi_house_dict:Dictionary[Vector2i, House]) -> void:
	_clear_tile_multis(house_grid)
	for pos in multi_house_dict.keys():
		var house: House = multi_house_dict[pos]
		if house.in_danger:
			multi_changed_houses[house] = []
			continue
		
		var all_multi_pos: Array[Vector2i]
		
		match house.res.name:
			"house_multi_around":
				all_multi_pos = get_multi_around(house)
			"house_multi_minus":
				all_multi_pos = get_multi_minus(house)
			"house_multi_line":
				all_multi_pos = get_multi_line(house)
			"house_multi_plus":
				all_multi_pos = get_multi_plus(house)
		
		all_multi_pos = remove_danger_cells(all_multi_pos)
		_multiply_with_given_pos(all_multi_pos, house)

func _multiply_with_given_pos(all_multi_pos: Array[Vector2i], house: House) -> void:
	var multi_group: Array[House] = []
	for multi_pos in all_multi_pos:
		if not house_grid.has(multi_pos):
			continue
		var current_house: House = house_grid[multi_pos]
		if current_house.multi_house:
			continue
		if not multi_group.has(current_house):
			current_house.current_points = current_house.current_points * house.current_points
			multi_group.append(current_house)
	multi_changed_houses[house] = multi_group

func remove_danger_cells(all_multi_pos: Array[Vector2i]) -> Array[Vector2i]:
	var danger_cells: Array[Vector2i] = wave_manager.wave_marker_tile_map_layer.get_danger_cells()
	for pos in danger_cells:
		if all_multi_pos.has(pos):
			all_multi_pos.erase(pos)
	return all_multi_pos

func get_multi_around(house: House) -> Array[Vector2i]:
	var pos: Vector2i = house.get_grid_pos()
	var all_multi_pos: Array[Vector2i]
	var neighbors: Array[Vector2i] = [
						pos + Vector2i(1, -1),  # up-right
						pos + Vector2i(1, 0),   # right
						pos + Vector2i(1, 1),	# down-right
						pos + Vector2i(0, 1),   # down
						pos + Vector2i(-1, 1),  # down-left
						pos + Vector2i(-1, 0),  # left
						pos + Vector2i(-1, -1),  # left-up
						pos + Vector2i(0, -1)   # up
					]
	for neighbor in neighbors:
		if sand_tile_map_layer.all_pos.has(neighbor):
			all_multi_pos.append(neighbor)
	return all_multi_pos
	

func get_multi_minus(house: House) -> Array[Vector2i]:
	var pos: Vector2i = house.get_grid_pos()
	var all_multi_pos: Array[Vector2i]
	var bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
	for x_pos in range(bounds.x, bounds.z):
		var current_pos = Vector2i(x_pos, pos.y)
		if current_pos == pos:
			continue
		all_multi_pos.append(current_pos)
	return all_multi_pos

func get_multi_line(house: House) -> Array[Vector2i]:
	var pos: Vector2i = house.get_grid_pos()
	var all_multi_pos: Array[Vector2i]
	var bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
	for y_pos in range(bounds.x, bounds.z):
		var current_pos = Vector2i(pos.x, y_pos)
		if current_pos == pos:
			continue
		all_multi_pos.append(current_pos)
	return all_multi_pos

func get_multi_plus(house: House) -> Array[Vector2i]:
	var pos: Vector2i = house.get_grid_pos()
	var all_multi_pos: Array[Vector2i]
	var bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
	for x_pos in range(bounds.x, bounds.z):
		var current_pos = Vector2i(x_pos, pos.y)
		if current_pos == pos:
			continue
		all_multi_pos.append(current_pos)
	for y_pos in range(bounds.y, bounds.w):
		var current_pos = Vector2i(pos.x, y_pos)
		if current_pos == pos:
			continue
		all_multi_pos.append(current_pos)
	return all_multi_pos

func _group_houses_by_color(house_dict: Dictionary) -> Array[Array]:
	var visited: Dictionary[Vector2i, bool] = {}
	var groups: Array[Array] = []
	
	for pos in house_dict.keys():
		var house: House = house_dict[pos]
		
		if house.in_danger:
			continue
		
		if visited.has(pos):
			continue
		
		# Start a new group with flood fill
		var group: Array[House] = []
		var color = house.get_color()
		var to_check: Array[Vector2i] = [pos]
		
		while to_check.size() > 0:
			var current_pos = to_check.pop_back()
			
			# Skip if already visited
			if visited.has(current_pos):
				continue
			
			# Check if this position has a house with matching color
			if not house_dict.has(current_pos):
				continue
			
			var current_house: House = house_dict[current_pos]
			if not current_house is House:
				continue
			
			if current_house.in_danger:
				continue
			
			if current_house.get_color() != color:
				continue
			
			# Add to group and mark as visited
			visited[current_pos] = true
			if not group.has(current_house) and not current_house.multi_house:
				group.append(current_house)
			
			# Check all 4 adjacent positions
			var neighbors = [
				current_pos + Vector2i(1, 0),   # right
				current_pos + Vector2i(-1, 0),  # left
				current_pos + Vector2i(0, 1),   # down
				current_pos + Vector2i(0, -1)   # up
			]
			
			for neighbor in neighbors:
				if not visited.has(neighbor):
					to_check.append(neighbor)
		
		# Add the group if it has houses
		if group.size() > 0:
			groups.append(group)
	
	return groups

func _get_biggest_color_groups() -> Array[Array]:
	var biggest_groups: Array[Array] = []
	for group: Array[House] in color_groups:
		var color_group: Array[House] = _color_group_in_groups(biggest_groups, group[0].flag.color)
		if color_group != []:
			if group[0].flag.current_value > color_group[0].flag.current_value:
				biggest_groups.erase(color_group)
				biggest_groups.append(group)
		else:
			biggest_groups.append(group)
	return biggest_groups

func _color_group_in_groups(groups: Array[Array], color: int) -> Array[House]:
	for group: Array[House] in groups:
		if group[0].flag.color == color:
			return group
	return []

func get_group_points(group: Array[House]) -> int:
	var points: int = 0
	
	for house: House in group:
		points += house.current_points
	
	return points

func set_flag_values() -> void:
	for house : House in house_grid.values():
		house.flag.current_value = house.current_points
		if house.multi_house and not house.in_danger:
			house.flag.set_flag_opacity(true)
			continue
		house.flag.set_flag_opacity(false)

func set_flag_modulate() -> void:
	for group in biggest_color_groups:
		for house: House in group:
			house.flag.set_flag_opacity(true)

func calculate_score() -> int:
	var points: int = 0
	for group: Array[House] in biggest_color_groups:
		for house in group:
			points += house.flag.current_value
	return points
