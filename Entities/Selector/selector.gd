class_name Selector
extends Node2D

@export var object_grid: Node2D

const OBJECT_MOVER = preload("uid://cgox6pb4mrk00")
var object_mover: ObjectMover

func _ready() -> void:
	object_grid.child_entered_tree.connect(_on_object_grid_child_entered_tree)

func _on_object_grid_child_entered_tree(node: Node) -> void:
	var grid_object = node as GridObject
	if is_instance_valid(grid_object):
		await grid_object.ready
		grid_object.selectable.selectable_selected.connect(_on_selectable_selected)

func _on_selectable_selected(grid_object: GridObject, selected: bool) -> void:
	if selected:
		if not object_mover:
			object_mover = OBJECT_MOVER.instantiate()
			object_mover.object_to_move = grid_object
			add_child(object_mover)
	else:
		if object_mover:
			object_mover.object_deselected()
