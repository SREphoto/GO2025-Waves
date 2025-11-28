class_name LittleGuySpawner
extends Node2D

@export var wave_manager: WaveManager
@export var house_manager: Node2D

@onready var object_grid: Node2D = %ObjectGrid

const LITTLE_GUY = preload("uid://btpjeah0ck4vi")

var little_guy_array : Array[LittleGuy] = []

func _ready() -> void:
	if house_manager:
		house_manager.house_spawned.connect(on_house_spawned)
	if wave_manager:
		wave_manager.send_wave.connect(panic)

func on_house_spawned(house: House) -> void:
	for size in house.size:
		var little_guy: LittleGuy = LITTLE_GUY.instantiate()
		little_guy.global_position = house.global_position + Vector2(house.size.pick_random() * GlobalVariables.GRID_SIZE)
		object_grid.add_child(little_guy)
		little_guy_array.append(little_guy)

func panic(min_time : float = 5.0, max_time : float = 10.0):
	for guy in little_guy_array:
		guy.start_panic(randf_range(min_time, max_time))
	SoundManager.voice_manager.start_panic()
