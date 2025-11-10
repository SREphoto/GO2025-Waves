class_name House
extends MovableGridObject

@onready var flag: Flag = $Flagpole
@onready var sprite_2d: Sprite2D = $Sprite2D

const GRID_COLLISION_SHAPE = preload("uid://bkek31gnkn0ip")

@onready var static_body_2d: StaticBody2D = $StaticBody2D

var res: HouseRescource:
	set(value):
		res = value
		size = res.size
		sprite_2d.frame = res.frames
		flag.position =  res.flag_pos
		_set_selectable_collision()
		_set_static_body_collision()

func _set_selectable_collision() -> void:
	for vector in size:
		var grid_collision_shape: CollisionShape2D = GRID_COLLISION_SHAPE.instantiate()
		grid_collision_shape.position = (vector * GlobalConfigs.GRID_SIZE)
		selectable.add_child(grid_collision_shape)

func _set_static_body_collision() -> void:
	for vector in size:
		var grid_collision_shape: CollisionShape2D = GRID_COLLISION_SHAPE.instantiate()
		grid_collision_shape.position = (vector * GlobalConfigs.GRID_SIZE)
		static_body_2d.add_child(grid_collision_shape)

func set_color(col : int):
	flag.color

func get_color():
	return flag.color

func destroy():
	queue_free()
