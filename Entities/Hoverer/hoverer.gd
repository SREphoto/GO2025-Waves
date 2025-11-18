class_name Hoverer
extends Node2D

@export var score_manager: ScoreManager

@onready var object_grid: Node2D = %ObjectGrid

func _ready() -> void:
	object_grid.child_entered_tree.connect(_on_object_grid_child_entered_tree)

func _on_object_grid_child_entered_tree(node: Node2D) -> void:
	var house = node as House
	if house:
		await house.ready
		house.mouse_entered_house.connect(on_mouse_entered_house)
		house.mouse_exited_house.connect(on_mouse_exited_house)

func on_mouse_entered_house(house: House) -> void:
	for group in score_manager.biggest_color_groups:
		if group.has(house):
			print(group)

func on_mouse_exited_house(_house: House) -> void:
	pass
