extends Node

@export var upgradable_shop_houses_array: Array[HouseRescource]
@export var owned_shop_houses_array: Array[HouseRescource]

@export var upgradable_houses_array: Array[HouseRescource]
@export var owned_houses_array: Array[HouseRescource]

var bosses_completed_last: int = 0
var bosses_completed_now: int

const GRID_SIZE = 32

var money: int = 0
