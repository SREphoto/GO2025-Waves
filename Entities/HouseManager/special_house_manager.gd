class_name StartHouseManager
extends Node2D

@onready var check_ray: CheckRay = $CheckRay
@onready var object_grid: Node2D = %ObjectGrid

const HOUSE = preload("uid://b2avbu36bburo")

@export var start_house_pos: Array[Vector2i]
@export var start_house_res: Array[HouseRescource]

signal house_spawned(house: House)

func _ready() -> void:
	spawn_all_houses()

func spawn_all_houses() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(0.2)
	await timer.timeout
	
	while not start_house_res.is_empty():
		_spawn_house()

func _spawn_house():
	if start_house_res.is_empty():
		return
	
	var house_res: HouseRescource = start_house_res.pop_back()
	var house_pos: Vector2i = start_house_pos.pop_back()
	
	var house: House = HOUSE.instantiate()
	house.set_grid_pos(house_pos)
	house.res = house_res
	object_grid.add_child(house)
	
	await house.house_done
	
	house_spawned.emit(house)
	

func get_house_on_pos(pos: Vector2) -> House:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	#Because the collider is a child of the house!
	return check_ray.get_collider().get_parent() as House

func house_on_pos(pos: Vector2) -> bool:
	check_ray.set_grid_pos(pos + Vector2(0.5, 0.5))
	check_ray.force_raycast_update()
	return check_ray.is_colliding()
