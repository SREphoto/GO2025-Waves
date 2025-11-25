class_name HouseRoll
extends Sprite2D

var cycling = true
var last_symbol = null

func _ready() -> void:
	_roll()

func _roll():
	while cycling:
		var tween_loop: Tween = create_tween()
		region_rect.position.y = 0.0
		tween_loop.tween_property(self, "region_rect:position:y", 192.0, 0.4)
		await tween_loop.finished
	
	var tween: Tween = create_tween()
	region_rect.position.y = 0.0
	tween.tween_property(self, "region_rect:position:y", last_symbol * 48, 0.1)
	await tween.finished

func stop(new_last_symbol : int):
	cycling = false
	last_symbol = new_last_symbol
