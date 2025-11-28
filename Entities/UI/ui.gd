class_name UI
extends CanvasLayer

@export var game: Game
@export var game_variables : GameVariables
@export var score_manager: ScoreManager

@onready var goal: Label = $GoalUI/BG/Goal
@onready var current_offering: Label = $GoalUI/BG/CurrentOffering

@onready var round_current: Label = $RoundUI/Sprite2D/RoundCurrent
@onready var waves_remaining: Label = $RoundUI/Sprite2D/WavesRemaining
@onready var time_remaining: Label = $RoundUI/Sprite2D/TimeRemaining
@onready var round_tracker: Sprite2D = $RoundUI/Sprite2D/RoundTracker

@onready var king: AnimatedSprite2D = $GoalUI/BG/King
@onready var king_fg: Sprite2D = $GoalUI/BG/King/KingFg

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var label_red: Label = $Control/V/P1/LabelRed
@onready var label_green: Label = $Control/V/P2/LabelGreen
@onready var label_blue: Label = $Control/V/P3/LabelBlue

@onready var health_bar: HealthBarUI = $HealthBar

var round_current_int: int = 0:
	set(value):
		if round_current_int != value:
			health_bar.initialize()
		round_current_int = value

signal start_wave

func _ready() -> void:
	game_variables.connect("values_changed", refresh)
	health_bar.game_variables = game_variables
	health_bar.connect_signal()
	health_bar.initialize()
	show_normal()

func refresh():
	goal.text = str(game_variables.current_goal)
	round_current_int = (game.current_round + 1)
	round_current.text = "Round " + str(round_current_int) + " / 6"
	round_tracker.frame = game.current_round
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

func show_normal():
	$GoalUI.visible = true
	$RoundUI.visible = true
	$Control.visible = true
	$CanvasModulate.visible = true
	$HealthBar.visible = false

func show_healthbar():
	$GoalUI.visible = false
	$RoundUI.visible = false
	$Control.visible = false
	$CanvasModulate.visible = false
	$HealthBar.visible = true

func blend_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 1), 0.2)
	health_bar.blend_in()

func blend_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 0), 0.2)
	health_bar.blend_out()
	await tween.finished
