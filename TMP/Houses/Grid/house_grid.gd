extends Node2D

@onready var tilemap: CustomTilemap = $Tilemap

var selected_house : House = null:
	set = _set_selected_house

const HOUSE = preload("uid://cv3qps6uuw6w1")

func _set_selected_house(value) -> void:
	selected_house = value

func _ready() -> void:
	tilemap.tile_data_changed.connect(_on_tile_data_changed)

func _on_tile_data_changed(pos: Vector2i, data: int) -> void:
	if data > -1:
		var house = HOUSE.instantiate()
		house.global_position = tilemap.map_to_local(pos)
		house.index = data
		add_child(house)
		house.house_selected.connect(_on_house_selected)

func _on_house_selected(house: House) -> void:
	if house.selected:
		selected_house = house
	else:
		selected_house = null
