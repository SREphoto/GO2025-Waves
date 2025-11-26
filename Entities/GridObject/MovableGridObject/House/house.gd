@tool
class_name House
extends MovableGridObject

@onready var flag: Flag = $Flagpole

@onready var sprites: Node2D = $Sprites
@onready var front: Sprite2D = $Sprites/SpritesFront/Front
@onready var back: Sprite2D = $Sprites/SpritesBack/Back

@onready var static_body_2d: StaticBody2D = $StaticBody2D

@onready var sel_coll_poly: CollisionPolygon2D = $Selectable/CollisionPolygon2D
@onready var stat_coll_poly: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

@export var res: HouseRescource:
	set = _set_res

const GRID_COLLISION_SHAPE = preload("uid://bkek31gnkn0ip")

var in_danger: bool = false
var selected : bool = false

var standard_points: int:
	set(value):
		standard_points = value
		current_points = standard_points
var current_points: int

var multi_house: bool = false

signal house_done()

func _ready() -> void:
	_set_res(res)
	_spawn()

func _set_res(value) -> void:
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

func get_color():
	return flag.color

func destroy():
	SoundManager.fall_house_player.play()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BOUNCE).tween_property(self, "scale", Vector2.ZERO, 0.5)
	await tween.finished
	queue_free()

func _spawn():
	SoundManager.spawn_house_player.play()
	self.scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)
	await tween.finished
	house_done.emit()

func stretch(dir : String):
	var horizontal = (dir == "Right" or dir == "Left")
	var tween = create_tween()
	if horizontal:
		tween.tween_property(sprites, "scale", Vector2(1.3, 0.8), 0.1)
	else:
		tween.tween_property(sprites, "scale", Vector2(0.8, 1.3), 0.1)

func squish(dir : String):
	var horizontal = (dir == "Right" or dir == "Left")
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	if horizontal:
		tween.tween_property(sprites, "scale", Vector2(0.9, 1.15), 0.15)
		tween.tween_property(sprites, "scale", Vector2(1.0, 1.0), 0.15)
	else:
		tween.tween_property(sprites, "scale", Vector2(1.15, 0.9), 0.15)
		tween.tween_property(sprites, "scale", Vector2(1.0, 1.0), 0.15)

func select():
	var tween = create_tween()
	tween.tween_property(sprites, "scale", Vector2(1.05, 0.95), 0.1)

func deselect():
	var tween = create_tween()
	tween.tween_property(sprites, "scale", Vector2(1.0, 1.0), 0.1)
