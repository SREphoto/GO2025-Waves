class_name Shop
extends CanvasLayer

@export var game_variables: GameVariables
@onready var multi_house: Sprite2D = $ColorRect/M/V/H/Slot1/MultiHouse

var cycle: bool = true

signal shopping_done(house_res: HouseRescource)

func enter() -> void:
	visible = true
	await get_tree().create_timer(0.5).timeout
	cycle = true
	_rand_houses()

func exit() -> void:
	cycle = false
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		cycle = false

func _rand_houses() -> void:
	var rand_res_arr: Array[HouseRescource] = GlobalVariables.owned_multi_houses_array.duplicate_deep()
	rand_res_arr.shuffle()
	while cycle:
		var tween: Tween = create_tween()
		multi_house.region_rect.position.x = 0.0
		tween.tween_property(multi_house, "region_rect:position:x", 128.0, 0.4)
		await tween.finished
	
	var rand_res: HouseRescource
	multi_house.region_rect.position.x = 0.0
	rand_res = rand_res_arr.pop_back()
	multi_house.texture = rand_res.sprite_sheet
	multi_house.hframes = rand_res.hframes
	multi_house.frame = rand_res.frame
	
	await get_tree().create_timer(1).timeout
	
	shopping_done.emit(rand_res)
