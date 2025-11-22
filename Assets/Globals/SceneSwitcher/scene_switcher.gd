extends Node

const HOMEPAGE = preload("uid://bea0lmunii7f3")
const GAME = preload("uid://cxkp8l2y2mw4")
const ENDSCENE = preload("uid://ctnqj58d24fjc")

const HOUSE_TOMBSTONE = preload("uid://der423hq24i8n")


func switch_game_to_end(game_scene : Game):
	var camera: ZoomCamera = game_scene.get_camera()
	var sand: SandTileMapLayer = game_scene.get_sand()
	var water: WaterTileMapLayer = game_scene.get_water()
	
	#var house_pos_arr: Array[Vector2i] = game_scene.house_manager.get_houses_on_grid().keys()
	
	var nodes_to_transfer = [camera, sand, water]
	
	for node in nodes_to_transfer:
		node.get_parent().remove_child(node)
	
	# If this is removed, errors are thrown because of signals still firing
	await get_tree().process_frame
	
	get_tree().change_scene_to_packed(ENDSCENE)
	await get_tree().process_frame
	
	var current_scene: EndScene = get_tree().current_scene
	for node in nodes_to_transfer:
		current_scene.add_child(node)
	
	#var house_res_array: Array[HouseRescource] = []
	#for pos in house_pos_arr:
		#house_res_array.append(HOUSE_TOMBSTONE)
	
	#current_scene.special_house_manager.start_house_pos = house_pos_arr
	#current_scene.special_house_manager.start_house_res = house_res_array
	
	current_scene.set_nav_region(sand.get_grid_bounds())

func switch_home_to_game() -> void:
	get_tree().change_scene_to_packed(GAME)

func switch_end_to_home() -> void:
	GlobalVariables.bosses_completed_last = GlobalVariables.bosses_completed_now
	get_tree().change_scene_to_packed(HOMEPAGE)
