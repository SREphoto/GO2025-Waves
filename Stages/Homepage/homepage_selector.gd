class_name HomepageSelector
extends Node2D

@export var object_grid: Node2D
@onready var house: House = $"../ObjectGrid/House"


const OBJECT_MOVER = preload("uid://cgox6pb4mrk00")
var object_mover: ObjectMover

var active: bool = true

func _ready() -> void:
	object_grid.child_entered_tree.connect(_on_object_grid_child_entered_tree)
	
	if is_instance_valid(house):
		await house.ready
		house.selectable.selectable_selected.connect(_on_selectable_selected)

func _on_object_grid_child_entered_tree(node: Node) -> void:
	var grid_object = node as GridObject
	if is_instance_valid(grid_object):
		await grid_object.ready
		grid_object.selectable.selectable_selected.connect(_on_selectable_selected)

func _on_selectable_selected(grid_object: GridObject, selected: bool) -> void:
	if selected and active:
		if not object_mover:
			object_mover = OBJECT_MOVER.instantiate()
			object_mover.object_to_move = grid_object
			object_grid.add_child(object_mover)
	else:
		if object_mover:
			object_mover.object_deselected()
