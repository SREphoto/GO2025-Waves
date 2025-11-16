class_name UI
extends CanvasLayer

@export var game_variables : GameVariables

@onready var goal: Label = $LeftTopUI/BG/Goal
@onready var current_offering: Label = $LeftTopUI/BG/CurrentOffering
@onready var waves_remaining: Label = $LeftBottomUI/Sprite2D/WavesRemaining
@onready var time_remaining: Label = $LeftBottomUI/Sprite2D/TimeRemaining

signal start_wave

func _ready() -> void:
	visible = true
	game_variables.connect("values_changed", refresh)

func refresh():
	goal.text = str(game_variables.current_goal)
	current_offering.text = str(game_variables.current_score)
	waves_remaining.text = str(game_variables.remaining_waves)
	time_remaining.text = str(game_variables.remaining_time)

func _on_skip_button_pressed() -> void:
	start_wave.emit()
