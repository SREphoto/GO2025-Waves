@tool
class_name NavigationRegion
extends NavigationRegion2D

@export var house_manager: HouseManager
@export var sand_tile_map_layer: SandTileMapLayer
@export var wave_manager: WaveManager

func _ready() -> void:
	sand_tile_map_layer.changed_grid_size.connect(on_changed_grid_size)
	house_manager.house_spawned.connect(on_house_spawned)
	wave_manager.mark_wave.connect(on_wave_marked)
	wave_manager.send_wave.connect(on_wave_sent)

func on_changed_grid_size() -> void:
	print("here")
	var grid_bounds = sand_tile_map_layer.get_grid_bounds()
	var outline: PackedVector2Array = [Vector2(grid_bounds.x, grid_bounds.y) * GlobalConfigs.GRID_SIZE,
	Vector2(grid_bounds.x, grid_bounds.w) * GlobalConfigs.GRID_SIZE,
	Vector2(grid_bounds.z, grid_bounds.w) * GlobalConfigs.GRID_SIZE,
	Vector2(grid_bounds.z, grid_bounds.y) * GlobalConfigs.GRID_SIZE]
	print(outline)
	navigation_polygon.clear_outlines()
	navigation_polygon.add_outline(outline)
	bake_navigation_polygon()

func on_house_spawned() -> void:
	bake_navigation_polygon()

func on_object_move_finished() -> void:
	bake_navigation_polygon()

func on_wave_marked() -> void:
	bake_navigation_polygon()

func on_wave_sent() -> void:
	bake_navigation_polygon()
