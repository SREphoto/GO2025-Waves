class_name ScoreManager
extends Node2D

@export var house_manager : HouseManager

func _ready() -> void:
	house_manager.house_spawned.connect(on_house_spawned)

func on_house_spawned() -> void:
	score()

func on_object_move_finished() -> void:
	score()

func score():
	var house_grid = house_manager.get_houses_on_grid()
	var groups = _group_houses_by_color(house_grid)
	print(groups)

func _group_houses_by_color(house_dict: Dictionary) -> Array[Array]:
	var visited: Dictionary[Vector2i, bool] = {}
	var groups: Array[Array] = []
	
	for pos in house_dict.keys():
		var house = house_dict[pos]
		
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
