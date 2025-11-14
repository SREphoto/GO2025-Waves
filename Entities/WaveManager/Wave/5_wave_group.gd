extends Node2D

@onready var wave_row: WaveRow = $WaveRow
@onready var wave_row_2a: WaveRow = $WaveRow2a
@onready var wave_row_2b: WaveRow = $WaveRow2b
@onready var wave_row_3a: WaveRow = $WaveRow3a
@onready var wave_row_3b: WaveRow = $WaveRow3b

func start_wave():
	wave_row.start_wave()
	await get_tree().create_timer(0.1).timeout
	wave_row_2a.start_wave()
	wave_row_2b.start_wave()
	await get_tree().create_timer(0.1).timeout
	wave_row_3a.start_wave()
	wave_row_3b.start_wave()
