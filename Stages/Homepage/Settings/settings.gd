class_name Settings
extends Node2D

@onready var music_slider: CustomSlider = $Music/MusicSlider
@onready var effect_slider: CustomSlider = $Sounds/EffectSlider
@onready var voices_slider: CustomSlider = $Voices/VoicesSlider

func _ready() -> void:
	music_slider.value_changed.connect(_on_music_slider_changed)
	effect_slider.value_changed.connect(_on_effect_slider_changed)
	voices_slider.value_changed.connect(_on_voices_slider_changed)

func _on_music_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(1, value)

func _on_effect_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(2, value)

func _on_voices_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(3, value)
