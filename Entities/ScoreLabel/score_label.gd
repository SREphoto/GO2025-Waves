class_name ScoreLabel
extends RichTextLabel

@export var reset_score: int = 0
var score: int:
	set(value):
		score = value
		_set_label(score)

func _ready() -> void:
	score = reset_score

func _set_label(score: int) -> void:
	if score > 0:
		text = str(score)
	else:
		text = '-'
