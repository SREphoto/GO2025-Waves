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

var multi_weights: PackedFloat32Array = PackedFloat32Array([1, 1, 1, 1])

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

signal shop_entered
signal shopping_done(house_res: HouseRescource)

func _ready() -> void:
	#Plus house more likely
	if GlobalVariables.rounds_played > 0:
		multi_weights[3] = GlobalVariables.rounds_played * 4

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
	var rand_res_arr: Array[HouseRescource] = GlobalVariables.owned_multi_houses_array.duplicate()
	var rand_index : int = rng.rand_weighted(multi_weights)
	for i in multi_weights.size():
		if i != rand_index:
			multi_weights[i] *= 2
	var rand_res : HouseRescource = rand_res_arr[rand_index]
	
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
