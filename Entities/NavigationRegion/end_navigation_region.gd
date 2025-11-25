class_name EndNavigationRegion
extends NavigationRegion2D

@export var progress_grid: ProgressGrid

func _ready() -> void:
	progress_grid.movement_done.connect(on_movement_done)

func on_movement_done() -> void:
	bake_navigation_polygon()
