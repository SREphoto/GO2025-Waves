class_name DragScreen
extends Node2D

var pressable: bool = true

var mouse_pressed_pos: Vector2 = Vector2.INF

signal dragged()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") and pressable:
		mouse_pressed_pos = get_global_mouse_position()
	if event.is_action_released("left_click") and pressable:
		mouse_pressed_pos = Vector2.INF
	if event is InputEventMouseMotion and not mouse_pressed_pos == Vector2.INF:
		var dist: float = mouse_pressed_pos.distance_to(get_global_mouse_position())
		if dist >= 32:
			dragged.emit()
