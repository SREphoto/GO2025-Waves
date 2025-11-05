class_name CheckRay
extends RayCast2D


func set_grid_pos(grid_pos: Vector2i):
	global_position = GlobalConfigs.GRID_SIZE * grid_pos
