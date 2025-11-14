class_name ScoreManager
extends Node2D

@export var house_manager : HouseManager
@export var wave_manager: WaveManager

var houses_scoring_dict: Dictionary[House, ScoringResource]

var house_grid: Dictionary[Vector2i, House]
var biggest_color_groups: Array[Array] = []

signal score_changed()

func _ready() -> void:
	house_manager.house_spawned.connect(on_house_spawned)
	wave_manager.mark_wave.connect(on_wave_marked)
	wave_manager.send_wave.connect(on_wave_sent)

func on_house_spawned() -> void:
	score()

func on_wave_marked() -> void:
	score()

func on_wave_sent() -> void:
	score()

func on_object_move_finished() -> void:
	score()

func score():
	house_grid = house_manager.get_houses_on_grid()
	var groups = _group_houses_by_color(house_grid)
	_set_house_scoring_dict(groups)
	_set_flag_values(groups)
	biggest_color_groups = _get_biggest_color_groups(groups)
	_set_falg_modulate()
	score_changed.emit()

func _group_houses_by_color(house_dict: Dictionary) -> Array[Array]:
	var visited: Dictionary[Vector2i, bool] = {}
	var groups: Array[Array] = []
	
	var danger_cells : Array[Vector2i] = wave_manager.wave_marker_tile_map_layer.get_danger_cells()
	
	for pos in house_dict.keys():
		var house: House = house_dict[pos]
		
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
			
			var current_house = house_dict[current_pos]
			if not current_house is House:
				continue
			
			if current_house.get_color() != color:
				continue
			
			if danger_cells.has(current_pos):
				continue
			
			# Add to group and mark as visited
			visited[current_pos] = true
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

#@export var color: COLORS
#@export var group: Array[Vector2i]
#@export var house_size: int
#@export var danger: bool
func _set_house_scoring_dict(groups: Array[Array]) -> void:
	houses_scoring_dict = {}
	var danger_cells : Array[Vector2i] = wave_manager.wave_marker_tile_map_layer.get_danger_cells()
	
	for pos in house_grid.keys():
		var house: House = house_grid[pos]
		
		var scoring_res: ScoringResource = ScoringResource.new()
		scoring_res = houses_scoring_dict.get_or_add(house, scoring_res)
		
		scoring_res.color = house.get_color()
		scoring_res.size.append(pos)
		
		if danger_cells.has(pos):
			scoring_res.danger = true

func _group_houses_by_color_new() -> void:
	for house in houses_scoring_dict.keys():
		for pos in houses_scoring_dict[house].size:
			var neighbors = [
				pos + Vector2i(1, 0),   # right
				pos + Vector2i(-1, 0),  # left
				pos + Vector2i(0, 1),   # down
				pos + Vector2i(0, -1)   # up
			]
			for neighbor in neighbors:
				var neighbor_house: House = house_grid.get(pos) as House
				if not neighbor_house or neighbor_house == house:
					continue
				

func _get_biggest_color_groups(groups: Array[Array]) -> Array[Array]:
	var biggest_groups: Array[Array] = []
	for group: Array[House] in groups:
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

func _set_flag_values(groups: Array[Array]) -> void:
	for house : House in house_grid.values():
		house.flag.current_value = 0
		house.flag.set_flag_opacity(false)
	
	for group in groups:
		for house : House in group:
			house.flag.current_value = group.size()
			house.flag.set_flag_opacity(false)

func _set_falg_modulate() -> void:
	for group in biggest_color_groups:
		for house: House in group:
			house.flag.set_flag_opacity(true)
