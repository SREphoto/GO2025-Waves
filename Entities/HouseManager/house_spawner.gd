class_name HouseSpawner
extends Node2D

@export var sand_tilemap: SandTileMapLayer

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

const HOUSE = preload("uid://b2avbu36bburo")

const SMALL_HOUSE = preload("uid://bhf2eld78b6wl")

var active: bool = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.space) and active:
		_spawn_house()

func _spawn_house():
	var rand: Vector2i = _rand_vect_on_grid()
	if rand != Vector2i(-100, -100):
		var house: House = HOUSE.instantiate()
		house.set_grid_pos(rand)
		house.res = SMALL_HOUSE
		object_grid.add_child(house)
		# TEMPORARY
		house.flag.color = randi_range(0, 2)
		house.flag.set_flag_color(house.flag.color)

func _rand_vect_on_grid() -> Vector2i:
	var all_pos_cop = sand_tilemap.all_pos.duplicate_deep()
	all_pos_cop.shuffle()
	for pos in all_pos_cop:
		if not _house_on_pos(pos):
			return pos
	return Vector2i(-100, -100)

func get_houses_on_grid() -> Dictionary[Vector2i, House]:
	var grid_vectors = sand_tilemap.all_pos
	var house_dict : Dictionary[Vector2i, House]
	for vector in grid_vectors:
		if _house_on_pos(vector):
			var house = _get_house_on_pos(vector) as House
			house_dict.get_or_add(vector, house)
	return house_dict

func _get_house_on_pos(pos: Vector2) -> House:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	#Because the collider is a child of the house!
	return check_ray.get_collider().get_parent() as House

func _house_on_pos(pos: Vector2) -> bool:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	return check_ray.is_colliding()
