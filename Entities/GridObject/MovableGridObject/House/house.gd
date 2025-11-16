@tool
class_name House
extends MovableGridObject

@onready var flag: Flag = $Flagpole
@onready var front: Sprite2D = $SpritesFront/Front
@onready var back: Sprite2D = $SpritesBack/Back

const GRID_COLLISION_SHAPE = preload("uid://bkek31gnkn0ip")

@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var sel_coll_poly: CollisionPolygon2D = $Selectable/CollisionPolygon2D
@onready var stat_coll_poly: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

@export var res: HouseRescource:
	set(value):
		res = value
		if res:
			if not Engine.is_editor_hint():
				await ready
			size = res.size
			front.position = res.sprite_offset
			front.texture = res.sprite_sheet
			front.hframes = res.hframes
			front.frame = res.frame
			if res.frame_back:
				back.visible = true
				back.frame = res.frame
			else:
				back.visible = false
			sel_coll_poly.polygon = res.sel_poly
			stat_coll_poly.polygon = res.stat_poly
			flag.position =  res.flag_pos
			standard_points = res.standard_points
			multi_house = res.multi_house
			if multi_house:
				flag.multi_house = true
				

var in_danger: bool = false

var standard_points: int:
	set(value):
		standard_points = value
		current_points = standard_points
var current_points: int

var multi_house: bool = false

signal house_done()

func _ready() -> void:
	_spawn()

func get_color():
	return flag.color

func destroy():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()

func _spawn():
	self.scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)
	await tween.finished
	house_done.emit()
