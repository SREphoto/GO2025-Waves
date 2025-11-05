class_name Selectable
extends Area2D

@export var grid_object: GridObject

var selected: bool = false:
	set(value):
		selected = value
		selectable_selected.emit(grid_object, selected)

signal selectable_selected(grid_object: GridObject, selected: bool)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed(GlobalNames.inputs.left_click):
		selected = true

func _input(event: InputEvent) -> void:
	if selected and event.is_action_released(GlobalNames.inputs.left_click):
		selected = false
