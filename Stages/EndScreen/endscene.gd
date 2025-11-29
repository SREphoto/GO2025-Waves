class_name EndScene
extends Node2D

@onready var follow_camera: FollowCamera = $FollowCamera

@onready var little_guy: LittleGuy = $ObjectGrid/LittleGuy

@onready var navigation_region_2d: NavigationRegion2D = $NavigationRegion2D

@onready var special_house_manager: StartHouseManager = $SpecialHouseManager

@onready var progress_grid: ProgressGrid = $ProgressGrid

@onready var drag_screen: DragScreen = $DragScreen

@onready var for_now: Label = $M/Control/H/ForNow

func _ready() -> void:
	drag_screen.dragged.connect(_on_screen_dragged)
	GlobalVariables.rounds_played += 1
	progress_grid.movement_done.connect(on_movement_done)
	
	var bosses_now: int = 0
	
	if GlobalVariables.hard_mode:
		for_now.text = "in hard mode"
		bosses_now = GlobalVariables.hard_bosses_completed_now
	else:
		for_now.text = "for now"
		bosses_now = GlobalVariables.bosses_completed_now
	
	
	follow_camera.position.y = 320
	await follow_camera.move_to_end()
	
	progress_grid.move_to_stage(bosses_now)
	
	RainLayer.fade_in_rain(200)

func _on_screen_dragged() -> void:
	follow_camera.move_camera_end_to_home()

func on_movement_done() -> void:
	drag_screen.pressable = true

func set_nav_region(bounds: Vector4i) -> void:
	navigation_region_2d.navigation_polygon.clear_outlines()
	var outline: PackedVector2Array = [
		Vector2(bounds.x, bounds.y) * GlobalVariables.GRID_SIZE,
		Vector2(bounds.x, bounds.w) * GlobalVariables.GRID_SIZE,
		Vector2(bounds.z, bounds.w) * GlobalVariables.GRID_SIZE,
		Vector2(bounds.z, bounds.y) * GlobalVariables.GRID_SIZE
	]
	navigation_region_2d.navigation_polygon.add_outline(outline)
	navigation_region_2d.bake_navigation_polygon()
