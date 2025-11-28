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

var hard_mode_unlocked: bool = true
var hard_mode: bool = false

var bosses_completed_max: int = 0
var bosses_completed_last: int = 0:
	set(value):
		bosses_completed_last = value
		bosses_completed_max = max(bosses_completed_max, bosses_completed_last)
var bosses_completed_now: int = 0:
	set(value):
		bosses_completed_now = clamp(value, 0, 5)

var rounds_played: int = 0

const GRID_SIZE = 32

var moves_total: int = 0
var moves_this_run: int = 0

var money: int = 0

var first_time: bool = false
var first_time_multi: bool = false
