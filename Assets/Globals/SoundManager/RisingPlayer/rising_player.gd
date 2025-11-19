class_name RisingAudioPlayer
extends AudioStreamPlayer

var count = 0

func play_rising(from_position : float = 0.0, reset : bool = false) -> void:
	if reset:
		reset_pitch()
	self.pitch_scale = pow(1.07, count)
	count += 1
	play(from_position)

func reset_pitch() -> void:
	count = 0
