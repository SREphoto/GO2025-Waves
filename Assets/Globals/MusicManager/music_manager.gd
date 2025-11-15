extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var music_switch_timer: Timer = $MusicSwitchTimer

func _ready() -> void:
	switch_music("GAMELOOP")

func switch_music(to: String) -> void:
	if music_player["parameters/switch_to_clip"] != to:
		match to:
			"GAMELOOP":
				_switch_gameloop_music()
			_:
				music_player["parameters/switch_to_clip"] = to
				music_switch_timer.stop()


func _switch_gameloop_music() -> void:
	music_switch_timer.stop()
	if randf() > 0.5:
		switch_music("GAMELOOP1")
		music_switch_timer.start(randf_range(10, 30))
	else:
		const tracks = ["GAMELOOP2", "GAMELOOP3", "GAMELOOP4"]
		switch_music(tracks.pick_random())
		music_switch_timer.start(randf_range(5, 20))
