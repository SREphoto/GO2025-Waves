class_name FollowCamera
extends Camera2D

@export var selector: Selector

var follow_object: GridObject

var initial_offset: Vector2

var std_rotation: float = -5

var std_pos: Vector2 = Vector2(0.0, -16.0)

func _ready() -> void:
	selector.object_selected.connect(on_object_selected)

func on_object_selected(object: GridObject) -> void:
	initial_offset = global_position - object.global_position
	follow_object = object

func _process(_delta: float) -> void:
	if follow_object:
		position = follow_object.position + initial_offset
		if position != std_pos:
			rotation = follow_object.rotation
		else:
			rotation = deg_to_rad(std_rotation) 
