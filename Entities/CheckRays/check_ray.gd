class_name CheckRay
extends RayCast2D

func set_grid_pos(grid_pos: Vector2):
	global_position = GlobalVariables.GRID_SIZE * grid_pos
