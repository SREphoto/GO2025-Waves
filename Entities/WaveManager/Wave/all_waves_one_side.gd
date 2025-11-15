class_name WaveSide
extends Node2D

@onready var _5_wave_group: Node2D = $"5WaveGroup"
@onready var _5_wave_group_2: Node2D = $"5WaveGroup2"
@onready var _5_wave_group_3: Node2D = $"5WaveGroup3"

var wave_group_count: int
var wave_group_finished_count: int

signal wave_side_finished()

func _ready() -> void:
	for wave_group: WaveGroup in get_children():
		wave_group_count += 1
		wave_group.wave_group_finished.connect(on_wave_group_finished)

func start_wave():
	wave_group_finished_count = 0
	_5_wave_group.start_wave()
	_5_wave_group_2.start_wave()
	_5_wave_group_3.start_wave()

func on_wave_group_finished() -> void:
	wave_group_finished_count += 1
	if wave_group_finished_count >= wave_group_count:
		wave_side_finished.emit()
