class_name HouseSpawner
extends Node2D

@export var sand_tilemap: SandTileMapLayer

@onready var object_grid: Node2D = %ObjectGrid
const HOUSE = preload("uid://b2avbu36bburo")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.space):
		_spawn_house()

func _spawn_house():
	var rand: Vector2i = _rand_vect_on_grid()
	var house: House = HOUSE.instantiate()
	house.set_grid_pos(rand)
	object_grid.add_child(house)

func _rand_vect_on_grid() -> Vector2i:
	var rand_x = randi_range(floori(-float(sand_tilemap.grid_size.x)/2.0), floori(float(sand_tilemap.grid_size.x)/2.0) - 1)
	var rand_y = randi_range(floori(-float(sand_tilemap.grid_size.y)/2.0), floori(float(sand_tilemap.grid_size.y)/2.0) - 1)
	return Vector2i(rand_x, rand_y)
