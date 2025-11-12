class_name LeftGUI
extends Control

@export var score_manager: ScoreManager

@onready var current_points: ScoreLabel = $M/V/PointsNext/Panel/H/RichTextLabel2

func _ready() -> void:
	score_manager.score_changed.connect(on_score_changed)

func on_score_changed() -> void:
	var points: int = 0
	for group: Array[House] in score_manager.biggest_color_groups:
		points += group[0].flag.current_value
	current_points.score = points
