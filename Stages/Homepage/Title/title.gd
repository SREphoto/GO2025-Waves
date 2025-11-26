extends Node2D

@onready var letters: Node2D = $Letters

var animating = true

func _ready():
	_animate()

func _animate():
	while animating:
		for letter in letters.get_children():
			var tween = create_tween()
			#tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN_OUT) #auch cool
			tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(letter, "position", Vector2.UP * 2, 0.2)
			tween.tween_property(letter, "position", Vector2.ZERO, 0.2)
			await get_tree().create_timer(0.2).timeout
			
		await get_tree().create_timer(2.0).timeout
