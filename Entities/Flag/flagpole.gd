class_name Flag
extends Node2D

@onready var flag: PanelContainer = $Sprite/Flag
@onready var label: Label = $Sprite/Flag/Label

@export var color : COLORS = COLORS.RED
@export var standard_value : int = 1
@export var current_value : int = 1:
	set(value):
		current_value = value
		set_flag_value(str(current_value))

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

func set_flag_opacity(in_biggest_group: bool) -> void:
	if in_biggest_group:
		flag.modulate = Color(1, 1, 1, 1)
	else:
		flag.modulate = Color(0.6, 0.6, 0.6, 1)
