class_name House
extends MovableGridObject

@onready var flagpole: Flag = $Flagpole

var res: HouseRescource:
	set(value):
		res = value
		await ready
		size = res.size
		sprite_2d.frame = res.frames.pick_random()

@onready var sprite_2d: Sprite2D = $Sprite2D
