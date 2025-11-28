extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ambience_player: AudioStreamPlayer = $AmbiencePlayer

func _ready() -> void:
	pass

func switch_music(to: String) -> void:
	if music_player["parameters/switch_to_clip"] != to:
		music_player["parameters/switch_to_clip"] = to

func switch_ambience(to: String) -> void:
	if ambience_player["parameters/switch_to_clip"] != to:
		ambience_player["parameters/switch_to_clip"] = to
