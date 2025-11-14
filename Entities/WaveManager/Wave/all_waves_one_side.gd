extends Node2D

@onready var _5_wave_group: Node2D = $"5WaveGroup"
@onready var _5_wave_group_2: Node2D = $"5WaveGroup2"
@onready var _5_wave_group_3: Node2D = $"5WaveGroup3"

func start_wave():
	_5_wave_group.start_wave()
	_5_wave_group_2.start_wave()
	_5_wave_group_3.start_wave()
