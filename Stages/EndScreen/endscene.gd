class_name EndScene
extends Node2D

@onready var little_guy: LittleGuy = $LittleGuy

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D

func set_nav_region(bounds: Vector4i) -> void:
	navigation_region_2d.navigation_polygon.clear_outlines()
	var outline: PackedVector2Array = [
		Vector2(bounds.x, bounds.y) * GlobalConfigs.GRID_SIZE,
		Vector2(bounds.x, bounds.w) * GlobalConfigs.GRID_SIZE,
		Vector2(bounds.z, bounds.w) * GlobalConfigs.GRID_SIZE,
		Vector2(bounds.z, bounds.y) * GlobalConfigs.GRID_SIZE
	]
	navigation_region_2d.navigation_polygon.add_outline(outline)
	navigation_region_2d.bake_navigation_polygon()
