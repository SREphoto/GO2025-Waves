@tool
class_name House
extends MovableGridObject

@onready var flag: Flag = $Flagpole
@onready var sprite_2d: Sprite2D = $SpritesFront/Front

const GRID_COLLISION_SHAPE = preload("uid://bkek31gnkn0ip")

@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var sel_coll_poly: CollisionPolygon2D = $Selectable/CollisionPolygon2D
@onready var stat_coll_poly: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

@export var res: HouseRescource:
	set(value):
		res = value
		if res:
			await ready
			size = res.size
			sprite_2d.position = res.sprite_offset
			sprite_2d.texture = res.sprite_sheet
			sprite_2d.hframes = res.hframes
			sprite_2d.frame = res.frame
			sel_coll_poly.polygon = res.sel_poly
			stat_coll_poly.polygon = res.stat_poly
			flag.position =  res.flag_pos

func set_color(col : int):
	flag.color

func get_color():
	return flag.color

func destroy():
	queue_free()
