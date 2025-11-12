class_name LeftGUI
extends Control

@export var score_manager: ScoreManager
@export var wave_manager: WaveManager

@onready var current_points_label: ScoreLabel = $M/V/PointsNext/Panel/H/ScoreLabel
@onready var points_label: ScoreLabel = $M/V/Points/Panel/H/ScoreLabel
@onready var wave_label: ScoreLabel = $M/V/WavesRemaining/Panel/VBoxContainer/HBoxContainer/ScoreLabel

func _ready() -> void:
	visible = true
	score_manager.score_changed.connect(on_score_changed)
	wave_manager.send_wave.connect(on_wave_sent)

func on_wave_sent() -> void:
	points_label.score += current_points_label.score
	wave_label.score -= 1

func on_score_changed() -> void:
	var points: int = 0
	for group: Array[House] in score_manager.biggest_color_groups:
		points += group[0].flag.current_value
	current_points_label.score = points
