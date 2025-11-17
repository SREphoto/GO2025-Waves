class_name Selector
extends Node2D


@export var score_manager: ScoreManager
@export var navigation_region: NavigationRegion

@onready var object_grid: Node2D = %ObjectGrid

const OBJECT_MOVER = preload("uid://cgox6pb4mrk00")
var object_mover: ObjectMover

var active: bool = true

func _ready() -> void:
	object_grid.child_entered_tree.connect(_on_object_grid_child_entered_tree)

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
			if score_manager:
				object_mover.object_move_finished.connect(score_manager.on_object_move_finished)
			if navigation_region:
				object_mover.object_move_finished.connect(navigation_region.on_object_move_finished)
	else:
		if object_mover:
			object_mover.object_deselected()
