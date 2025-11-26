extends Node

@onready var game_scene : Game = null

enum STATES {START, GAMELOOP, WAVE, SHOP, GAMEOVER}

var state: STATES:
	set = _on_state_changed

var last_round = false

func _on_state_changed(value) -> void:
	state = value
	if last_round:
		_change_state_last_round()
	else:
		_change_state_normal()

func _change_state_last_round() -> void:
	match state:
		STATES.START:
			SceneSwitcher.switch_end_to_home()
			MusicManager.switch_music("START")
			RainLayer.fade_out()
		STATES.GAMELOOP:
			SoundManager.voice_manager.start_voices()
			MusicManager.switch_music("ENDGAME")
			RainLayer.fade_in()
		STATES.WAVE:
			MusicManager.switch_music("ENDGAME")
			RainLayer.fade_in()
		STATES.SHOP: # not possible in last round -> change to won
			MusicManager.switch_music("SHOP")
		STATES.GAMEOVER:
			SceneSwitcher.switch_game_to_end(game_scene)
			SoundManager.voice_manager.stop_voices()
			MusicManager.switch_music("GAMEOVER")
			RainLayer.fade_in(200)

func _change_state_normal() -> void:
	match state:
		STATES.START:
			SceneSwitcher.switch_end_to_home()
			MusicManager.switch_music("START")
			RainLayer.fade_out()
		STATES.GAMELOOP:
			SoundManager.voice_manager.start_voices()
			MusicManager.switch_music("GAMELOOP")
			RainLayer.fade_out()
		STATES.WAVE:
			MusicManager.switch_music("WAVE")
			RainLayer.fade_in()
		STATES.SHOP:
			MusicManager.switch_music("SHOP")
		STATES.GAMEOVER:
			SceneSwitcher.switch_game_to_end(game_scene)
			SoundManager.voice_manager.stop_voices()
			MusicManager.switch_music("GAMEOVER")
			RainLayer.fade_in(200)
