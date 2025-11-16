extends Node

const HOMEPAGE = preload("uid://bea0lmunii7f3")
const START = preload("uid://cxkp8l2y2mw4")
const ENDSCENE = preload("uid://ctnqj58d24fjc")


func switch_start_to_end(start : Start):
	var camera: ZoomCamera = start.get_camera()
	var sand: SandTileMapLayer = start.get_sand()
	var water: WaterTileMapLayer = start.get_water()
	
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
	
	current_scene.set_nav_region(sand.get_grid_bounds())
	
