extends Node

const HOMEPAGE = preload("uid://bea0lmunii7f3")
const GAME = preload("uid://cxkp8l2y2mw4")
const ENDSCENE = preload("uid://ctnqj58d24fjc")
const WIN_SCENE = preload("uid://xft4hu2ih81x")


const HOUSE_TOMBSTONE = preload("uid://der423hq24i8n")

func switch_game_to_win():
	get_tree().change_scene_to_packed(WIN_SCENE)

func switch_game_to_end(_game_scene: Game):
	get_tree().change_scene_to_packed(ENDSCENE)

func switch_home_to_game() -> void:
	get_tree().change_scene_to_packed(GAME)

func switch_end_to_home() -> void:
	if GlobalVariables.hard_mode:
		GlobalVariables.hard_bosses_completed_last = GlobalVariables.hard_bosses_completed_now
	else:
		GlobalVariables.bosses_completed_last = GlobalVariables.bosses_completed_now
	get_tree().change_scene_to_packed(HOMEPAGE)
