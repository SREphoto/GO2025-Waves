extends Node

enum STATES {START, GAMELOOP, WAVE, SHOP, GAMEOVER}

var state: STATES:
	set = _on_state_changed

func _on_state_changed(value) -> void:
	state = value
	match state:
		STATES.START:
			MusicManager.switch_music("START")
		STATES.GAMELOOP:
			MusicManager.switch_music("GAMELOOP")
		STATES.WAVE:
			MusicManager.switch_music("WAVE")
		STATES.SHOP:
			MusicManager.switch_music("SHOP")
		STATES.GAMEOVER:
			MusicManager.switch_music("GAMEOVER")
