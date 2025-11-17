class_name LittleGuySpawner
extends Node2D

@export var house_manager: Node2D

@onready var object_grid: Node2D = %ObjectGrid

const LITTLE_GUY = preload("uid://btpjeah0ck4vi")

func _ready() -> void:
	house_manager.house_spawned.connect(on_house_spawned)

func on_house_spawned(house: House) -> void:
	for size in house.size:
		var little_guy: LittleGuy = LITTLE_GUY.instantiate()
		little_guy.global_position = house.global_position + Vector2(house.size.pick_random() * GlobalVariables.GRID_SIZE)
		object_grid.add_child(little_guy)
