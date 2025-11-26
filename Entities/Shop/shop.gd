class_name Shop
extends CanvasLayer

@export var game_variables: GameVariables
@onready var slotmachine: SlotMachine = $ColorRect/Control/Slotmachine
@onready var house_roll_1: HouseRoll = $ColorRect/Control/Slotmachine/V/H/Slot1/HouseRoll
@onready var house_roll_2: HouseRoll = $ColorRect/Control/Slotmachine/V/H/Slot2/HouseRoll
@onready var house_roll_3: HouseRoll = $ColorRect/Control/Slotmachine/V/H/Slot3/HouseRoll
@onready var house_rolls = [
	house_roll_1, house_roll_2, house_roll_3,
]

var active = true

signal shop_entered
signal shopping_done(house_res: HouseRescource)

func _ready() -> void:
	#enter()
	pass

func enter() -> void:
	SoundManager.slot_audio_manager.play_slot_loop()
	active = true
	shop_entered.emit()
	visible = true
	slotmachine.reset_slot()
	for roll: HouseRoll in house_rolls:
		roll.roll()

func exit() -> void:
	active = false
	visible = false

func _rand_houses() -> void:
	# select a random special house
	var rand_res_arr: Array[HouseRescource] = GlobalVariables.owned_multi_houses_array.duplicate_deep()
	rand_res_arr.shuffle()
	var rand_res: HouseRescource = rand_res_arr.pop_back()
	
	for roll in house_rolls:
		await get_tree().create_timer(0.5).timeout
		SoundManager.slot_audio_manager.play_stop()
		roll.stop(rand_res["frame"])
	
	await get_tree().create_timer(1.0).timeout
	SoundManager.slot_audio_manager.play_win()
	await get_tree().create_timer(1.5).timeout
	
	shopping_done.emit(rand_res)

func stop_spinning():
	_rand_houses()
