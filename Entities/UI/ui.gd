class_name UI
extends CanvasLayer

@export var game_variables : GameVariables
@export var score_manager: ScoreManager

@onready var goal: Label = $LeftTopUI/BG/Goal
@onready var current_offering: Label = $LeftTopUI/BG/CurrentOffering
@onready var waves_remaining: Label = $LeftBottomUI/Sprite2D/WavesRemaining
@onready var time_remaining: Label = $LeftBottomUI/Sprite2D/TimeRemaining

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var label_red: Label = $Control/M/V/P1/LabelRed
@onready var label_green: Label = $Control/M/V/P2/LabelGreen
@onready var label_blue: Label = $Control/M/V/P3/LabelBlue


signal start_wave

func _ready() -> void:
	visible = true
	game_variables.connect("values_changed", refresh)

func refresh():
	goal.text = str(game_variables.current_goal)
	current_offering.text = str(game_variables.current_score)
	waves_remaining.text = str(game_variables.remaining_waves)
	var remaining_time: int = max(0, game_variables.remaining_time)
	time_remaining.text = str(remaining_time)
	set_biggest_group_labels()

func clear_biggest_group_labels() -> void:
	label_red.text = "-"
	label_green.text = "-"
	label_blue.text = "-"

func set_biggest_group_labels() -> void:
	clear_biggest_group_labels()
	for group: Array[House] in score_manager.biggest_color_groups:
		var points: String = str(score_manager.get_group_points(group))
		match group[0].flag.color:
			Flag.COLORS.RED:
				label_red.text = points
			Flag.COLORS.GREEN:
				label_green.text = points
			Flag.COLORS.BLUE:
				label_blue.text = points

func _on_skip_button_pressed() -> void:
	start_wave.emit()

func blend_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 1), 0.8)

func blend_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 0), 0.8)
