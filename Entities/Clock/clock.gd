class_name Clock
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func play_ticks(speed: float):
	animation_player.speed_scale = speed
	audio_stream_player.pitch_scale = speed
	animation_player.play("Tick")
