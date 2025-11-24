class_name VoiceManager
extends Node

@onready var normal_voice_player: AudioStreamPlayer = $NormalVoicePlayer
@onready var panic_voice_player: AudioStreamPlayer = $PanicVoicePlayer
@onready var timer: Timer = $Timer

var panicking = false
var playing = true
var timer_range = [3.0, 5.0]

func _ready() -> void:
	timer.start(1.0)

func _on_timer_timeout() -> void:
	timer.stop()
	if not playing:
		return
	if panicking:
		panic_voice_player.play()
	else:
		normal_voice_player.play()
	timer.start(randf_range(timer_range[0], timer_range[1]))

func start_voices():
	timer.stop()
	panicking = false
	playing = true
	timer_range = [3.0, 5.0]
	_on_timer_timeout()

func start_panic():
	if not panicking:
		timer.stop()
		panicking = true
		playing = true
		timer_range = [0.2, 0.6]
		_on_timer_timeout()

func stop_voices():
	playing = false
	timer.stop()
