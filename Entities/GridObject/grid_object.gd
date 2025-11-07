@abstract class_name GridObject
extends Node2D

@export var size: Array[Vector2i] = []:
	set(value):
		size = value
		mid_pos = get_middle_pos()

var mid_pos: Vector2

func set_grid_pos(grid_pos: Vector2i):
	global_position = GlobalConfigs.GRID_SIZE * grid_pos
	global_position += Vector2(16, 16)

func get_middle_pos() -> Vector2:
	var corners: Array[Vector2] = []
	
	for dir in [-1, 1]:
		var last_pos: Vector2 = Vector2.ZERO
		for pos in size:
			if (dir * pos.x) > last_pos.x:
				last_pos.x = (dir * pos.x)
			if (dir * pos.y) > last_pos.y:
				last_pos.y = (dir * pos.y)
		corners.append(last_pos)
	
	var middle: Vector2 = (corners[0] + corners[1])/2
	return middle
