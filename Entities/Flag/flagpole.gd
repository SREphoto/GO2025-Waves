class_name Flag
extends Node2D

@onready var pole: Sprite2D = $Pole
@onready var flag: PanelContainer = $Pole/Flag
@onready var label: Label = $Pole/Flag/Label


@export var color : COLORS = COLORS.RED:
	set(value):
		color = value
		set_flag_color(color)
@export var standard_value : int = 1
@export var current_value : int = 1:
	set(value):
		current_value = value
		var value_str: String
		if value > 0:
			value_str = str(current_value)
		else:
			value_str = '-'
		set_flag_value(value_str)

enum COLORS {
	RED,
	GREEN,
	BLUE,
	GRAY
}

var multi_house: bool = false:
	set = set_multi_house

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
		COLORS.GRAY:
			style = preload("uid://uxgj5j41wtk3")
	flag.add_theme_stylebox_override("panel", style)

func set_flag_value(value : String):
	if multi_house:
		label.text = "*" + value
	else:
		label.text = value

func set_flag_opacity(shown: bool) -> void:
	if shown:
		flag.modulate = Color(1, 1, 1, 1)
	else:
		flag.modulate = Color(0.6, 0.6, 0.6, 1)

func set_multi_house(value: bool) -> void:
	multi_house = value
	if not multi_house:
		return
		
	pole.self_modulate = Color(1, 1, 1, 0)
