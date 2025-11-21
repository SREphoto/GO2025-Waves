class_name Hoverer
extends Node2D

@export var house_manager: HouseManager
@export var score_manager: ScoreManager
@export var hovered_tile_map_layer: HoveredTileMapLayer

@onready var object_grid: Node2D = %ObjectGrid

var old_house: House = null

var active: bool = false

func _ready() -> void:
	score_manager.biggest_color_groups_changed.connect(on_biggest_color_groups_changed)

func on_biggest_color_groups_changed() -> void:
	if not active:
		return
	_check_if_house()

func _input(event: InputEvent) -> void:
	if not active:
		return
	if event is InputEventMouseMotion:
		_check_if_house()

func _check_if_house() -> void:
	var mouse_pos = hovered_tile_map_layer.local_to_map(get_global_mouse_position())
	if house_manager.house_on_pos(mouse_pos):
		var house: House = house_manager.get_house_on_pos(mouse_pos)
		if not house:
			return
		house_is_multiplied(house)
		set_hovered_tilemap(house)
		if house != old_house:
			house_not_multiplied(old_house)
		old_house = house
	else:
		house_not_multiplied(old_house)
		old_house = null
		hovered_tile_map_layer.clear_tilemap()

func set_hovered_tilemap(house: House) -> void:
	var has_group: bool = false
	for group in score_manager.biggest_color_groups:
		if group.has(house):
			has_group = true
			hovered_tile_map_layer.set_tilemap(group)
			hovered_tile_map_layer.set_tilemap_modulate(house.flag.color)
	if not has_group:
		if house.multi_house and not house.in_danger:
			var all_pos: Array[Vector2i]
			match house.res.name:
				"house_multi_around":
					all_pos = score_manager.get_multi_around(house)
				"house_multi_minus":
					all_pos = score_manager.get_multi_minus(house)
				"house_multi_plus":
					all_pos = score_manager.get_multi_plus(house)
				"house_multi_line":
					all_pos = score_manager.get_multi_line(house)
			all_pos = score_manager.remove_danger_cells(all_pos)
			hovered_tile_map_layer.set_tilemap_wit_pos_arr(all_pos)
			hovered_tile_map_layer.set_tilemap_modulate(house.flag.color)
		else:
			hovered_tile_map_layer.clear_tilemap()

func house_not_multiplied(old_house: House) -> void:
	if old_house:
		old_house.flag.label.text = str(old_house.current_points)

func house_is_multiplied(house: House) -> void:
	var all_multies: int = 1
	var multiplied: bool = false
	for multiplied_houses in score_manager.multi_changed_houses.values():
		if multiplied_houses.has(house):
			multiplied = true
			var multi_house: House = score_manager.multi_changed_houses.find_key(multiplied_houses)
			all_multies = multi_house.current_points
	if multiplied:
		house.flag.label.text = str(house.current_points) + " " + str(house.standard_points) + "*" + str(all_multies)
