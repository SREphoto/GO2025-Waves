@tool
class_name SandTileMapLayer
extends TileMapLayer

@export var grid_size: Vector2 :
	set(value):
		grid_size = value
		_set_tilemap()
		_set_all_pos()

var all_pos: Array[Vector2i]


func _set_tilemap() -> void:
	clear()
	for row in range(floori(-float(grid_size.x)/2.0) - 1, floori(float(grid_size.x)/2.0) + 1):
		for col in range(floori(-float(grid_size.y)/2.0) - 1, floori(float(grid_size.y)/2.0) + 1):
			set_cell(Vector2i(row, col), 0, Vector2(0, 0))
	set_cells_terrain_connect(get_used_cells(), 0, 0, false)

func _set_all_pos() -> void:
	all_pos = []
	for row in range(floori(-float(grid_size.x)/2.0), floori(float(grid_size.x)/2.0)):
		for col in range(floori(-float(grid_size.y)/2.0), floori(float(grid_size.y)/2.0)):
			all_pos.append(Vector2i(row, col))
