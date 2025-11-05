@tool
class_name SandTileMapLayer
extends TileMapLayer

@export var grid_size: Vector2 :
	set(value):
		grid_size = value
		_set_tilemap()

func _set_tilemap() -> void:
	clear()
	for row in range(floori(-float(grid_size.x)/2.0) - 1, floori(float(grid_size.x)/2.0) + 1):
		for col in range(floori(-float(grid_size.y)/2.0) - 1, floori(float(grid_size.y)/2.0) + 1):
			set_cell(Vector2i(row, col), 0, Vector2(0, 0))
	set_cells_terrain_connect(get_used_cells(), 0, 0, false)
