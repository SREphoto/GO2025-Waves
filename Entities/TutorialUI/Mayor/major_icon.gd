class_name MayorIcon
extends AnimatedSprite2D

func reset():
	scale = Vector2.ZERO

func appear():
	reset()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale:x", 5.0, 0.2)
	tween.tween_property(self, "scale:y", 5.0, 0.4)

func disappear():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale:x", 0.0, 0.4)
	tween.tween_property(self, "scale:y", 0.0, 0.2)
	await tween.finished
