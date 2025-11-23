@tool
class_name WaveMarkerTileMap
extends TileMapLayer

@export var wave_manager: WaveManager
@export var sand_tile_map_layer: SandTileMapLayer

func _ready() -> void:
	wave_manager.mark_wave.connect(_on_mark_wave)
	wave_manager.finished_waves.connect(_on_finished_waves)

func _on_mark_wave() -> void:
	for dir: WaveManager.DIRECTIONS in wave_manager.directions:
		_set_tilemap(dir)

func _set_tilemap(dir: WaveManager.DIRECTIONS) -> void:
	var grid_bounds: Vector4i = sand_tile_map_layer.get_grid_bounds()
	match dir:
		wave_manager.DIRECTIONS.LEFT, wave_manager.DIRECTIONS.RIGHT:
			for depth in range(wave_manager.depth):
				var row: int
				match dir:
					wave_manager.DIRECTIONS.LEFT:
						row = grid_bounds.x + depth
					wave_manager.DIRECTIONS.RIGHT:
						row = grid_bounds.z - 1 - depth
				for col in range(grid_bounds.y, grid_bounds.w):
					set_cell(Vector2i(row, col), 2, Vector2(3, 3))
		_:
			for row in range(grid_bounds.x, grid_bounds.z):
				for depth in range(wave_manager.depth):
					var col: int
					match dir:
						wave_manager.DIRECTIONS.UP:
							col = grid_bounds.y + depth
						wave_manager.DIRECTIONS.DOWN:
							col = grid_bounds.w - 1 - depth
					set_cell(Vector2i(row, col), 2, Vector2(3, 3))
	set_cells_terrain_connect(get_used_cells(), 0, 2, false)

func _on_finished_waves() -> void:
	clear()

func get_danger_cells() -> Array[Vector2i]:
	return get_used_cells()
