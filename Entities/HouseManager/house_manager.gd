class_name HouseManager
extends Node2D

@export var sand_tilemap: SandTileMapLayer
@export var wave_marker_tile_map_layer: WaveMarkerTileMap

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

enum HOUSE_SIZES{ONE, TWO, THREE, FOUR, MULTI}

const HOUSE = preload("uid://b2avbu36bburo")

const HOUSE_ARRAY_RES_ONE: HouseArrayRescource = preload("uid://c3lrp7xjq6rsk")
const HOUSE_ARRAY_RES_TWO: HouseArrayRescource = preload("uid://ttgp1nmc6xx3")
const HOUSE_ARRAY_RES_THREE: HouseArrayRescource = preload("uid://ccydnracsqhx3")
const HOUSE_ARRAY_RES_FOUR: HouseArrayRescource = preload("uid://4ifk5bscputi")

var active: bool = true

#var house_size_to_grid_size: Dictionary = {
	#HOUSE_SIZES.ONE : [[Vector2i.ZERO], [Vector2.ONE]],
	#HOUSE_SIZES.TWO : [[Vector2i.ZERO], [Vector2.ONE]],
	#HOUSE_SIZES.THREE : [[Vector2i.ZERO], [Vector2.ONE]],
	#HOUSE_SIZES.FOUR : [[Vector2i.ZERO], [Vector2.ONE]],
	#}

var house_size_dict: Dictionary[HOUSE_SIZES, Array] = {
	HOUSE_SIZES.ONE : HOUSE_ARRAY_RES_ONE.house_res_array,
	HOUSE_SIZES.TWO : HOUSE_ARRAY_RES_TWO.house_res_array,
	HOUSE_SIZES.THREE : HOUSE_ARRAY_RES_THREE.house_res_array,
	HOUSE_SIZES.FOUR: HOUSE_ARRAY_RES_FOUR.house_res_array,
	HOUSE_SIZES.MULTI: GlobalVariables.owned_multi_houses_array
	}
var size_weights: PackedFloat32Array = PackedFloat32Array([1, 1, 1, 0, 0])

var color_weights: PackedFloat32Array = PackedFloat32Array([1, 1, 1])

var start_house_sizes: Array[HOUSE_SIZES] = [HOUSE_SIZES.ONE, HOUSE_SIZES.TWO, HOUSE_SIZES.THREE]

@export var special_house_round: Dictionary[int, HOUSE_SIZES]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal house_spawned(house: House)

func _ready() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	
	if GlobalVariables.first_time:
		timer.start(0.8)
		await timer.timeout
		spawn_specific_house_size(start_house_sizes.pop_front())
	else:
		spawn_special_or_random_house(0)

func spawn_specific_house(house_res: HouseRescource) -> bool:
	var rand: Vector2i = _check_free_grid_pos_for_size(house_res.size)
	
	if rand == Vector2i(-1000, -1000):
		#No place to spawn house
		return false
	
	_spawn_house(rand, house_res)
	return true

func spawn_specific_house_size(house_size: HOUSE_SIZES) -> bool:
	var house_size_res_array: Array[HouseRescource] = (house_size_dict[house_size]).duplicate_deep()
	house_size_res_array.shuffle()
	
	while not house_size_res_array.is_empty():
		var house_res: HouseRescource = house_size_res_array.pop_back()
		var rand: Vector2i = _check_free_grid_pos_for_size(house_res.size)
		if rand == Vector2i(-1000, -1000):
			#No place to spawn house
			continue
		for i in size_weights.size():
			if not i == house_size:
				size_weights[i] *= 2
		_spawn_house(rand, house_res)
		return true
	
	return false

func spawn_special_or_random_house(current_round: int) -> void:
	if not start_house_sizes.is_empty():
		for i in start_house_sizes.size():
			await get_tree().create_timer(0.8).timeout
			spawn_specific_house_size(start_house_sizes.pop_front())
	elif special_house_round.has(current_round):
		spawn_specific_house_size(special_house_round[current_round])
	else:
		spawn_random_house()

func spawn_random_house() -> void:
	var house_size: HOUSE_SIZES
	house_size = rng.rand_weighted(size_weights) as HOUSE_SIZES
	
	#Check for biggest possible house and the position
	while house_size >= 0 and not spawn_specific_house_size(house_size):
		house_size = (house_size - 1) as HOUSE_SIZES

func _spawn_house(pos: Vector2i, house_res: HouseRescource):
	var house: House = HOUSE.instantiate()
	house.set_grid_pos(pos)
	house.res = house_res
	object_grid.add_child(house)
	# TEMPORARY
	if not house.multi_house:
		house.flag.color = rng.rand_weighted(color_weights) as Flag.COLORS
	else:
		house.flag.color = Flag.COLORS.GRAY
	
	if not house.multi_house:
		for i in color_weights.size():
			if not i == house.flag.color:
				color_weights[i] *= 2
	
	await house.house_done
	
	house_spawned.emit(house)
	

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

func get_multi_houses_on_grid(house_dict: Dictionary[Vector2i, House]) -> Dictionary[Vector2i, House]:
	var multi_house_dict: Dictionary[Vector2i, House] = {}
	for pos: Vector2i in house_dict.keys():
		var house: House = house_dict[pos]
		if house.multi_house:
			multi_house_dict.get_or_add(pos, house)
	
	return multi_house_dict

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
