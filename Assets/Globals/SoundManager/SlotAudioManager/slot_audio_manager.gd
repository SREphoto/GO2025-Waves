class_name SlotAudioManager
extends Node

@onready var slot_win_player: AudioStreamPlayer = $SlotWinPlayer
@onready var slot_loop_player: AudioStreamPlayer = $SlotLoopPlayer
@onready var slot_stop_player: AudioStreamPlayer = $SlotStopPlayer
@onready var lever_player: AudioStreamPlayer = $LeverPlayer


func play_slot_loop():
	# reset pitch scale
	slot_loop_player.pitch_scale = 0.9
	slot_loop_player.play()

func play_stop():
	await get_tree().create_timer(0.3).timeout
	slot_loop_player.pitch_scale *= 0.9
	slot_stop_player.play()

func play_win():
	slot_win_player.play()
	var tween = create_tween()
	tween.tween_property(slot_loop_player, "pitch_scale", 0.001, 0.2)
	await tween.finished
	slot_loop_player.stop()

func play_lever():
	lever_player.play()
