class_name HouseSpawner
extends Node2D

@export var sand_tilemap: SandTileMapLayer

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

const HOUSE = preload("uid://b2avbu36bburo")

const SMALL_HOUSE = preload("uid://bhf2eld78b6wl")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.space):
		_spawn_house()

func _spawn_house():
	var rand: Vector2i = _rand_vect_on_grid()
	if rand != Vector2i(-100, -100):
		var house: House = HOUSE.instantiate()
		house.set_grid_pos(rand)
		house.res = SMALL_HOUSE
		object_grid.add_child(house)
		

func _rand_vect_on_grid() -> Vector2i:
	var all_pos_cop = sand_tilemap.all_pos.duplicate_deep()
	all_pos_cop.shuffle()
	for pos in all_pos_cop:
		if not _house_on_pos(pos):
			return pos
	return Vector2i(-100, -100)

func _house_on_pos(pos: Vector2) -> bool:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	return check_ray.is_colliding()
