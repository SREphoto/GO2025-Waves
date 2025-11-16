class_name WaveGroup
extends Node2D

@onready var wave_row_1: WaveRow = $WaveRow
@onready var wave_row_2a: WaveRow = $WaveRow2a
@onready var wave_row_2b: WaveRow = $WaveRow2b
@onready var wave_row_3a: WaveRow = $WaveRow3a
@onready var wave_row_3b: WaveRow = $WaveRow3b

var wave_row_count: int
var wave_row_finished_count: int

signal wave_group_finished()
signal wave_group_moved(dist: int)

func _ready() -> void:
	for wave_row: WaveRow in get_children():
		wave_row_count += 1
		wave_row.wave_row_finished.connect(_on_wave_row_finished)
	wave_row_1.wave_row_moved.connect(_on_wave_row_moved)

func start_wave():
	wave_row_finished_count = 0
	wave_row_1.start_wave()
	await get_tree().create_timer(0.1).timeout
	wave_row_2a.start_wave()
	wave_row_2b.start_wave()
	await get_tree().create_timer(0.1).timeout
	wave_row_3a.start_wave()
	wave_row_3b.start_wave()

func _on_wave_row_finished() -> void:
	wave_row_finished_count += 1
	if wave_row_finished_count >= wave_row_count:
		wave_group_finished.emit()

func _on_wave_row_moved(dist: int) -> void:
	wave_group_moved.emit(dist)
