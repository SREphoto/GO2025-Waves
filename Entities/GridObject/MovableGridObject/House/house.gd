class_name House
extends MovableGridObject

@onready var flag: Flag = $Flagpole
@onready var sprite_2d: Sprite2D = $Sprite2D

var res: HouseRescource:
	set(value):
		res = value
		await ready
		size = res.size
		sprite_2d.frame = res.frames.pick_random()

func set_color(col : int):
	flag.color

func get_color():
	return flag.color

func destroy():
	queue_free()
