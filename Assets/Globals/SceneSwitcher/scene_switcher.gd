extends Node

const HOMEPAGE = preload("uid://bea0lmunii7f3")
const GAME = preload("uid://cxkp8l2y2mw4")
const ENDSCENE = preload("uid://ctnqj58d24fjc")

const HOUSE_TOMBSTONE = preload("uid://der423hq24i8n")


func switch_game_to_end(_game_scene : Game):
	# If this is removed, errors are thrown because of signals still firing
	#await get_tree().process_frame
	
	get_tree().change_scene_to_packed(ENDSCENE)
	#await get_tree().process_frame

func switch_home_to_game() -> void:
	get_tree().change_scene_to_packed(GAME)

func switch_end_to_home() -> void:
	GlobalVariables.bosses_completed_last = GlobalVariables.bosses_completed_now
	get_tree().change_scene_to_packed(HOMEPAGE)
