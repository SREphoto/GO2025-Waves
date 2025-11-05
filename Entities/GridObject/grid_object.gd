@abstract class_name GridObject
extends Node2D

@export var size: Array[Vector2i] = []

func set_grid_pos(grid_pos: Vector2i):
	global_position = GlobalConfigs.GRID_SIZE * grid_pos
	global_position += Vector2(16, 16)
