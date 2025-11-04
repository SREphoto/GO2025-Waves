class_name HouseGrid
extends Node2D

@onready var tilemap: CustomTilemap = $Tilemap

var selected_house : House = null:
	set = _set_selected_house

const HOUSE = preload("uid://cv3qps6uuw6w1")

func _set_selected_house(value) -> void:
	selected_house = value
	if selected_house:
		_calculate_house_endpoints(selected_house)

func _calculate_house_endpoints(house: House) -> void:
	var pos = tilemap.tile_data_dict.find_key(house.index)
	var endpoints: Dictionary[String, Vector2i]
	for i in tilemap.grid_size:
		var left: Vector2i = Vector2i(pos.x - i, pos.y)
		var right: Vector2i = Vector2i(pos.x + i, pos.y)
		var top: Vector2i = Vector2i(pos.x, pos.y - i)
		var down: Vector2i = Vector2i(pos.x, pos.y + i)
		if tilemap.tile_data_dict.has(left) and tilemap.tile_data_dict.get(left) > -1:
			endpoints.get_or_add("Left", left)
		if tilemap.tile_data_dict.has(right) and tilemap.tile_data_dict.get(right) > -1:
			endpoints.get_or_add("Right", right)
		if tilemap.tile_data_dict.has(top) and tilemap.tile_data_dict.get(top) > -1:
			endpoints.get_or_add("Top", top)
		if tilemap.tile_data_dict.has(down) and tilemap.tile_data_dict.get(down) > -1:
			endpoints.get_or_add("Down", down)
	print(endpoints)

func _ready() -> void:
	tilemap.tile_data_changed.connect(_on_tile_data_changed)

func _on_tile_data_changed(pos: Vector2i, data: int) -> void:
	if data > -1:
		var house : House = HOUSE.instantiate()
		house.global_position = tilemap.map_to_local(pos)
		house.index = data
		add_child(house)
		house.house_selected.connect(_on_house_selected)

func _on_house_selected(house: House) -> void:
	if house.selected:
		selected_house = house
	else:
		selected_house = null
