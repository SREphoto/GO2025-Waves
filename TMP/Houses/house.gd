class_name House
extends StaticBody2D

var selected: bool = false

var index: int

signal house_selected(house: House)

func _on_pick_collider_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		selected = not selected
		house_selected.emit(self)
