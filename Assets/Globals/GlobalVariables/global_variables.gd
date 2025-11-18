extends Node

@export var upgradable_multi_houses_array: Array[HouseRescource] = HOUSE_ARRAY_RES_MULTI.house_res_array.duplicate_deep()
@export var owned_multi_houses_array: Array[HouseRescource]

@export var upgradable_houses_one_array: Array[HouseRescource] = HOUSE_ARRAY_RES_ONE.house_res_array.duplicate_deep()
@export var upgradable_houses_two_array: Array[HouseRescource] = HOUSE_ARRAY_RES_TWO.house_res_array.duplicate_deep()
@export var upgradable_houses_three_array: Array[HouseRescource] = HOUSE_ARRAY_RES_THREE.house_res_array.duplicate_deep()
@export var upgradable_houses_four_array: Array[HouseRescource] = HOUSE_ARRAY_RES_FOUR.house_res_array.duplicate_deep()

const HOUSE_ARRAY_RES_ONE = preload("uid://c3lrp7xjq6rsk")
const HOUSE_ARRAY_RES_TWO = preload("uid://ttgp1nmc6xx3")
const HOUSE_ARRAY_RES_THREE = preload("uid://ccydnracsqhx3")
const HOUSE_ARRAY_RES_FOUR = preload("uid://4ifk5bscputi")
const HOUSE_ARRAY_RES_MULTI = preload("uid://tdk2guk68owq")

var bosses_completed_max: int = 0
var bosses_completed_last: int = 0
var bosses_completed_now: int

const GRID_SIZE = 32

var money: int = 0

func _ready() -> void: 
	owned_multi_houses_array.append(upgradable_multi_houses_array.pop_at(0))
