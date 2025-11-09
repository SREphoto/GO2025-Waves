extends Sprite2D
class_name Flag

@onready var flag: PanelContainer = $Flag
@onready var label: Label = $Flag/Label

func set_flag_color(col : String):
	var style
	match col:
		"R":
			style = preload("uid://d2u7pjgqkhni1")
		"G":
			style = preload("uid://dvigpxi5gueqt")
		"B":
			style = preload("uid://b1iyke7tm7rbh")
	flag.add_theme_stylebox_override("panel", style)

func set_flag_value(value : String):
	label.text = value
