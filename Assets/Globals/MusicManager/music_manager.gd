extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	switch_music("GAMELOOP")

func switch_music(to: String) -> void:
	if music_player["parameters/switch_to_clip"] != to:
		music_player["parameters/switch_to_clip"] = to
