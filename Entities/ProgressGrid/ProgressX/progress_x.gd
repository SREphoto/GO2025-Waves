extends Sprite2D

func _ready() -> void:
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "scale", Vector2(1.0, 1.0), 0.5)
