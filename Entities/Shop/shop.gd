class_name Shop
extends CanvasLayer

@export var game_variables: GameVariables
@onready var house_roll_1: HouseRoll = $ColorRect/Control/V/H/Slot1/HouseRoll
@onready var house_roll_2: HouseRoll = $ColorRect/Control/V/H/Slot2/HouseRoll
@onready var house_roll_3: HouseRoll = $ColorRect/Control/V/H/Slot3/HouseRoll

@onready var pull_player: AnimationPlayer = $ColorRect/Control/Slotmachine/PullPlayer

@onready var house_rolls = [
	house_roll_1, house_roll_2, house_roll_3,
]

var active = true

signal shop_entered
signal shopping_done(house_res: HouseRescource)

func enter() -> void:
	active = true
	shop_entered.emit()
	visible = true
	await get_tree().create_timer(0.5).timeout

func exit() -> void:
	active = false
	visible = false

func rand_houses() -> void:
	# select a random special house
	var rand_res_arr: Array[HouseRescource] = GlobalVariables.owned_multi_houses_array.duplicate_deep()
	rand_res_arr.shuffle()
	var rand_res: HouseRescource = rand_res_arr.pop_back()
	
	for roll in house_rolls:
		await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
		roll.stop(rand_res["frame"])
	
	await get_tree().create_timer(1).timeout
	
	shopping_done.emit(rand_res)
