class_name UI
extends CanvasLayer

@export var game_variables : GameVariables

@onready var goal: Label = $LeftTopUI/BG/Goal
@onready var current_offering: Label = $LeftTopUI/BG/CurrentOffering
@onready var waves_remaining: Label = $LeftBottomUI/Sprite2D/WavesRemaining

func _ready() -> void:
	visible = true
	game_variables.connect("values_changed", refresh)

func refresh():
	goal.text = str(game_variables.current_goal)
	current_offering.text = str(game_variables.current_score)
	waves_remaining.text = str(game_variables.remaining_waves)
