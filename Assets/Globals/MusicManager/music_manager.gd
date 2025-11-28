extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer
@onready var speed_island_player: AudioStreamPlayer = $Node/SpeedIslandPlayer
@onready var speed_endgame_player: AudioStreamPlayer = $Node/SpeedEndgamePlayer

var current_clip = "START"
var current_player : AudioStreamPlayer = null

func _ready() -> void:
	current_player = speed_island_player

func switch_music(to: String) -> void:
	reset_current_player()
	if music_player["parameters/switch_to_clip"] != to or current_player.playing:
		current_player.stop()
		if music_player.volume_db < -22.0:
			_fade_in(music_player)
		music_player["parameters/switch_to_clip"] = to
		current_clip = to

func switch_ambience(to: String) -> void:
	if ambience_player["parameters/switch_to_clip"] != to:
		ambience_player["parameters/switch_to_clip"] = to

func reset_current_player():
	if current_player:
		current_player.pitch_scale = 1.0

func speed_up(value: float = 1.2):
	var position = 0.0
	if music_player.playing:
		position = music_player.get_playback_position()
	
	print(current_clip)
	match current_clip:
		"GAMELOOP":
			_fade_out(music_player)
			if not speed_island_player.playing:
				speed_island_player.play(position)
			current_player = speed_island_player
		"ENDGAME":
			_fade_out(music_player)
			if not speed_endgame_player.playing:
				speed_endgame_player.play(position)
			current_player = speed_endgame_player
		_:
			return
	var tween = create_tween()
	tween.tween_property(current_player, "pitch_scale", value, 0.3)

func _fade_in(player: AudioStreamPlayer, duration: float = 0.05):
	player.play()
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -20.0, duration)

func _fade_out(player: AudioStreamPlayer, duration: float = 0.5):
	var tween := create_tween()
	tween.tween_property(player, "volume_db", -80.0, duration)
	tween.tween_callback(player.stop)
