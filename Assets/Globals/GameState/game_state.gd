extends Node

enum STATES {START, GAMELOOP, WAVE, SHOP, GAMEOVER}

@onready var game_scene : Game = null

var state: STATES:
	set = _on_state_changed

func _on_state_changed(value) -> void:
	state = value
	match state:
		STATES.START:
			MusicManager.switch_music("START")
			RainLayer.fade_out()
		STATES.GAMELOOP:
			MusicManager.switch_music("GAMELOOP")
			RainLayer.fade_out()
		STATES.WAVE:
			MusicManager.switch_music("WAVE")
			RainLayer.fade_in()
		STATES.SHOP:
			MusicManager.switch_music("SHOP")
			RainLayer.fade_out()
		STATES.GAMEOVER:
			SceneSwitcher.switch_game_to_end(game_scene)
			MusicManager.switch_music("GAMEOVER")
			RainLayer.fade_in()
