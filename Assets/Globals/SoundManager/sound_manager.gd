extends Node

@onready var rising_pop_player: RisingAudioPlayer = $RisingPopPlayer
@onready var swipe_house_player: AudioStreamPlayer = $SwipeHousePlayer
@onready var fall_house_player: AudioStreamPlayer = $FallHousePlayer
@onready var spawn_house_player: AudioStreamPlayer = $SpawnHousePlayer
@onready var change_slider_player: AudioStreamPlayer = $ChangeSliderPlayer
@onready var voice_manager: VoiceManager = $VoiceManager

func _ready() -> void:
	pass
