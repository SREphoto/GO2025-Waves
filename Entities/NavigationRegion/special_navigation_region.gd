class_name SpecialNavigationRegion
extends NavigationRegion2D

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	
	bake_navigation_polygon()
