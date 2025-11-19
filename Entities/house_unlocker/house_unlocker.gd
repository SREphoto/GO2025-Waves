class_name HouseUnlocker
extends Node2D

@onready var shop_object_grid: Node2D = %ShopObjectGrid

var multi_houses: Array[House]
var one_houses: Array[House]
var two_houses: Array[House]
var three_houses: Array[House]

func _ready() -> void:
	for house: House in shop_object_grid.get_children():
		if house.res.multi_house:
			multi_houses.append(house)
			house.modulate = Color(0.6, 0.6, 0.6, 1)
		else:
			match house.res.size.size():
				1:
					one_houses.append(house)
				2:
					two_houses.append(house)
				3:
					three_houses.append(house)
