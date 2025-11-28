extends Node

@onready var game_scene : Game = null

enum STATES {START, GAMELOOP, WAVE, SHOP, GAMEOVER}

var state: STATES:
	set = _on_state_changed

var last_round = false

func _on_state_changed(value) -> void:
	state = value
	if last_round or GlobalVariables.hard_mode:
		_change_state_last_round()
	else:
		_change_state_normal()

func _change_state_last_round() -> void:
	match state:
		STATES.START:
			last_round = false
			SceneSwitcher.switch_end_to_home()
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("START")
		STATES.GAMELOOP:
			SoundManager.voice_manager.start_voices()
			MusicManager.ambience_player.play()
			MusicManager.switch_music("ENDGAME")
			MusicManager.switch_ambience("RAIN")
			RainLayer.fade_in_rain(200)
		STATES.WAVE:
			MusicManager.ambience_player.play()
			MusicManager.switch_music("ENDGAME")
			MusicManager.switch_ambience("THUNDER")
			RainLayer.fade_in_rain(200)
		STATES.SHOP: # not possible in last round -> change to won (!?!)
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("ENDGAME")
			MusicManager.switch_ambience("RAIN")
		STATES.GAMEOVER:
			MusicManager.ambience_player.stop()
			SceneSwitcher.switch_game_to_end(game_scene)
			SoundManager.voice_manager.stop_voices()
			MusicManager.switch_music("GAMEOVER")
			RainLayer.fade_in_rain(200)

func _change_state_normal() -> void:
	match state:
		STATES.START:
			last_round = false
			SceneSwitcher.switch_end_to_home()
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("START")
			RainLayer.fade_out_rain()
		STATES.GAMELOOP:
			SoundManager.voice_manager.start_voices()
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("GAMELOOP")
			RainLayer.fade_out_rain()
		STATES.WAVE:
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("WAVE")
			RainLayer.fade_in_rain()
		STATES.SHOP:
			MusicManager.ambience_player.stop()
			MusicManager.switch_music("SHOP")
			RainLayer.fade_out_rain()
		STATES.GAMEOVER:
			SceneSwitcher.switch_game_to_end(game_scene)
