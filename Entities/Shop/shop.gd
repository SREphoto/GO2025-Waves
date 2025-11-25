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

const MAX_DRAG := 300.0

var drag_start_y := 0.0
var dragging := false
var active = false

signal shop_entered
signal shopping_done(house_res: HouseRescource)

func enter() -> void:
	active = true
	shop_entered.emit()
	visible = true
	await get_tree().create_timer(0.5).timeout
	#_rand_houses()

func exit() -> void:
	active = false
	visible = false

func _rand_houses() -> void:
	# select a random special house
	var rand_res_arr: Array[HouseRescource] = GlobalVariables.owned_multi_houses_array.duplicate_deep()
	rand_res_arr.shuffle()
	var rand_res: HouseRescource = rand_res_arr.pop_back()
	
	for roll in house_rolls:
		await get_tree().create_timer(randf_range(0.1, 0.5)).timeout
		roll.stop(rand_res["frame"])
	
	await get_tree().create_timer(1).timeout
	
	shopping_done.emit(rand_res)

func _ready() -> void:
	pull_player.play("Pull")
	pull_player.pause()

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
		if dragging:
			drag_start_y = event.position.y
			pull_player.pause()
		else:
			pull_player.play()
	elif dragging and event is InputEventMouseMotion:
		var dy = max(event.position.y - drag_start_y, 0.0)
		var t = clamp(dy / MAX_DRAG, 0.0, 0.95)
		pull_player.seek(t * pull_player.current_animation_length, true)

func stop_spinning():
	active = false
	_rand_houses()
