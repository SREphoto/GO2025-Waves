@tool
class_name WaterTileMapLayer
extends TileMapLayer

@export var sand_tile_map_layer: SandTileMapLayer

var y_to_x: float = 1.77

var size: Vector2

func _ready() -> void:
	if not Engine.is_editor_hint():
		y_to_x = (get_viewport_rect().size.x / get_viewport_rect().size.y)
	sand_tile_map_layer.changed_grid_size.connect(_on_grid_size_changed)

func _on_grid_size_changed() -> void:
	size.y = sand_tile_map_layer.grid_size.y
	size.x = ceil(float(sand_tile_map_layer.grid_size.y) * y_to_x)
	_set_tilemap()

func _set_tilemap() -> void:
	clear()
	for row in range(floori(-float(size.x)/2.0) - 4, ceili(float(size.x)/2.0) + 4):
		for col in range(floori(-float(size.y)/2.0) - 4, ceili(float(size.y)/2.0) + 4):
			set_cell(Vector2i(row, col), 0, Vector2(0, 3))
