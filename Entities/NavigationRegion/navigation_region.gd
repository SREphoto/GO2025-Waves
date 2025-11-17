@tool
class_name NavigationRegion
extends NavigationRegion2D

@export var house_manager: HouseManager
@export var sand_tile_map_layer: SandTileMapLayer
@export var wave_manager: WaveManager

func _ready() -> void:
	if sand_tile_map_layer:
		sand_tile_map_layer.changed_grid_size.connect(on_changed_grid_size)
	if house_manager:
		house_manager.house_spawned.connect(on_house_spawned)
	if wave_manager:
		wave_manager.mark_wave.connect(on_wave_marked)
		wave_manager.finished_waves.connect(on_wave_finished)

func on_changed_grid_size() -> void:
	var grid_bounds = sand_tile_map_layer.get_grid_bounds()
	var outline: PackedVector2Array = [Vector2(grid_bounds.x, grid_bounds.y) * GlobalVariables.GRID_SIZE,
	Vector2(grid_bounds.x, grid_bounds.w) * GlobalVariables.GRID_SIZE,
	Vector2(grid_bounds.z, grid_bounds.w) * GlobalVariables.GRID_SIZE,
	Vector2(grid_bounds.z, grid_bounds.y) * GlobalVariables.GRID_SIZE]
	navigation_polygon.clear_outlines()
	navigation_polygon.add_outline(outline)
	bake_navigation_polygon()

func on_house_spawned(_house: House) -> void:
	while is_baking():
		await bake_finished
	bake_navigation_polygon()

func on_object_move_finished() -> void:
	if is_baking():
		await bake_finished
	bake_navigation_polygon()

func on_wave_marked() -> void:
	if is_baking():
		await bake_finished
	bake_navigation_polygon()

func on_wave_finished() -> void:
	if is_baking():
		await bake_finished
	bake_navigation_polygon()
