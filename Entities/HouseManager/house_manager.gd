class_name HouseManager
extends Node2D

@export var sand_tilemap: SandTileMapLayer

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

enum HOUSE_SIZES{ONE = 1, TWO = 2, THREE = 3, FOUR = 4}

const HOUSE = preload("uid://b2avbu36bburo")

const ONE: HouseArrayRescource = preload("uid://bbv6w31svdaei")
const TWO: HouseArrayRescource = preload("uid://eju5yj8xtp40")
const THREE: HouseArrayRescource = preload("uid://684uhs5wswfg")
const FOUR: HouseArrayRescource = preload("uid://cf3qyt0uhvo80")

var active: bool = true

var house_size_to_grid_size: Dictionary = {
	HOUSE_SIZES.ONE : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.TWO : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.THREE : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.FOUR : [[Vector2i.ZERO], [Vector2.ONE]]
	}

var house_size_dict: Dictionary[HOUSE_SIZES, HouseArrayRescource] = {
	HOUSE_SIZES.ONE : ONE,
	HOUSE_SIZES.TWO : TWO,
	HOUSE_SIZES.THREE : THREE,
	HOUSE_SIZES.FOUR: FOUR
	}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.space) and active:
		_spawn_house()

func _spawn_house():
	var empty_grid: Array[Vector2i] = _get_empty_grid_tiles()
	if empty_grid.is_empty():
		return
	
	var house_size: HOUSE_SIZES = randi_range(1, HOUSE_SIZES.size()) as HOUSE_SIZES
	while house_size > empty_grid.size():
		house_size -= 1 as HOUSE_SIZES
	
	var house_size_array: HouseArrayRescource = house_size_dict[house_size]
	var house_res: HouseRescource = house_size_array.house_res_array.pick_random()
	
	var rand: Vector2i = _check_free_grid_pos_for_size(house_res.size)
	
	while rand == Vector2i(-1000, -1000):
		house_size -= 1 as HOUSE_SIZES
		if house_size < 1:
			return
		house_size_array = house_size_dict[house_size]
		house_res = house_size_array.house_res_array.pick_random()
		rand = _check_free_grid_pos_for_size(house_res.size)
	
	
	var house: House = HOUSE.instantiate()
	house.set_grid_pos(rand)
	object_grid.add_child(house)
	house.sprite_2d.texture = house_size_array.houses_tile_atlas
	house.sprite_2d.hframes = house_size_array.h_frames
	house.sprite_2d.position = house_size_array.offset
	house.res = house_res
	# TEMPORARY
	house.flag.color = randi_range(0, 2)
	house.flag.set_flag_color(house.flag.color)

func _check_free_grid_pos_for_size(house_res_size: Array[Vector2i]) -> Vector2i:
	var all_pos_cop = sand_tilemap.all_pos.duplicate_deep()
	all_pos_cop.shuffle()
	for pos in all_pos_cop:
		var valid: bool = true
		for vector in house_res_size:
			if house_on_pos(pos + vector):
				valid = false
		if valid:
			return(pos)
	return Vector2i(-1000, -1000)

func get_houses_on_grid() -> Dictionary[Vector2i, House]:
	var grid_vectors = sand_tilemap.all_pos
	var house_dict : Dictionary[Vector2i, House]
	for vector in grid_vectors:
		if house_on_pos(vector):
			var house = get_house_on_pos(vector) as House
			house_dict.get_or_add(vector, house)
	return house_dict

func _get_empty_grid_tiles() -> Array[Vector2i]:
	var grid_vectors = sand_tilemap.all_pos
	var empty_grid_tiles : Array[Vector2i]
	for vector in grid_vectors:
		if not house_on_pos(vector):
			empty_grid_tiles.append(vector)
	return empty_grid_tiles

func get_house_on_pos(pos: Vector2) -> House:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	#Because the collider is a child of the house!
	return check_ray.get_collider().get_parent() as House

func house_on_pos(pos: Vector2) -> bool:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	return check_ray.is_colliding()
