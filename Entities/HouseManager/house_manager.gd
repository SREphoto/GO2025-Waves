class_name HouseManager
extends Node2D

@export var sand_tilemap: SandTileMapLayer
@export var wave_marker_tile_map_layer: WaveMarkerTileMap

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

enum HOUSE_SIZES{ONE, TWO, THREE, FOUR}

const HOUSE = preload("uid://b2avbu36bburo")

const HOUSE_ARRAY_RES_ONE: HouseArrayRescource = preload("uid://c3lrp7xjq6rsk")
const HOUSE_ARRAY_RES_TWO: HouseArrayRescource = preload("uid://ttgp1nmc6xx3")
const HOUSE_ARRAY_RES_THREE: HouseArrayRescource = preload("uid://ccydnracsqhx3")
const HOUSE_ARRAY_RES_FOUR: HouseArrayRescource = preload("uid://4ifk5bscputi")

var active: bool = true

var house_size_to_grid_size: Dictionary = {
	HOUSE_SIZES.ONE : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.TWO : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.THREE : [[Vector2i.ZERO], [Vector2.ONE]],
	HOUSE_SIZES.FOUR : [[Vector2i.ZERO], [Vector2.ONE]]
	}
var weights: PackedFloat32Array = PackedFloat32Array([1, 1, 1, 0])

var house_size_dict: Dictionary[HOUSE_SIZES, HouseArrayRescource] = {
	HOUSE_SIZES.ONE : HOUSE_ARRAY_RES_ONE,
	HOUSE_SIZES.TWO : HOUSE_ARRAY_RES_TWO,
	HOUSE_SIZES.THREE : HOUSE_ARRAY_RES_THREE,
	HOUSE_SIZES.FOUR: HOUSE_ARRAY_RES_FOUR
	}

var start_house_sizes: Array[HOUSE_SIZES] = [HOUSE_SIZES.ONE, HOUSE_SIZES.TWO, HOUSE_SIZES.THREE]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal house_spawned()

func _ready() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await timer.timeout
	
	while not start_house_sizes.is_empty():
		timer.start(0.2)
		await timer.timeout
		_spawn_house()

func _spawn_house():
	var house_size: HOUSE_SIZES
	if not start_house_sizes.is_empty():
		house_size = start_house_sizes.pop_front()
	else:
		house_size = rng.rand_weighted(weights) as HOUSE_SIZES
	
	var house_size_res_array: Array[HouseRescource] = (house_size_dict[house_size].house_res_array).duplicate_deep()
	house_size_res_array.shuffle()
	var house_res: HouseRescource = house_size_res_array.pop_back()
	
	var rand: Vector2i = _check_free_grid_pos_for_size(house_res.size)
	
	while true:
		var done: bool = false
		if house_size < 0:
			return
		house_size_res_array = (house_size_dict[house_size].house_res_array).duplicate_deep()
		house_size_res_array.shuffle()
		while not house_size_res_array.is_empty():
			house_res = house_size_res_array.pop_back()
			rand = _check_free_grid_pos_for_size(house_res.size)
			if rand != Vector2i(-1000, -1000):
				done = true
				break
		if done:
			break
		house_size -= 1 as HOUSE_SIZES
	
	var house: House = HOUSE.instantiate()
	house.set_grid_pos(rand)
	house.res = house_res
	object_grid.add_child(house)
	# TEMPORARY
	house.flag.color = randi_range(0, 2)
	house.flag.set_flag_color(house.flag.color)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	house_spawned.emit()
	

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
	var danger_cells : Array[Vector2i] = wave_marker_tile_map_layer.get_danger_cells()
	
	for vector in grid_vectors:
		if house_on_pos(vector):
			var house = get_house_on_pos(vector) as House
			house.in_danger = false
			house_dict.get_or_add(vector, house)
	
	for pos in house_dict.keys():
		if danger_cells.has(pos):
			var house: House = house_dict[pos]
			house.in_danger = true
	
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
