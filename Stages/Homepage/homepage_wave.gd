extends Node2D

@onready var _5_wave_group: Node2D = $"5WaveGroup"
@onready var _5_wave_group_2: Node2D = $"5WaveGroup2"
@onready var _5_wave_group_3: Node2D = $"5WaveGroup3"

func _ready() -> void:
	while true:
		start_wave()
		await get_tree().create_timer(8).timeout

func start_wave():
	_5_wave_group.start_wave()
	_5_wave_group_2.start_wave()
	_5_wave_group_3.start_wave()
