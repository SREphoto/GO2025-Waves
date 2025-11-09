extends Sprite2D
class_name Flag

@onready var flag: PanelContainer = $Flag
@onready var label: Label = $Flag/Label

@export var color : COLORS = COLORS.RED
@export var standard_value : int = 1
@export var current_value : int = 1

enum COLORS {
	RED,
	GREEN,
	BLUE
}

func _ready() -> void:
	set_flag_color(color)

func set_flag_color(col):
	var style
	match col:
		COLORS.RED:
			style = preload("uid://d2u7pjgqkhni1")
		COLORS.GREEN:
			style = preload("uid://dvigpxi5gueqt")
		COLORS.BLUE:
			style = preload("uid://b1iyke7tm7rbh")
	flag.add_theme_stylebox_override("panel", style)

func set_flag_value(value : String):
	label.text = value
