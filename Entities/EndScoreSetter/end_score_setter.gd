class_name EndScoreSetter
extends Node2D

@export var score: Label
@export var highscore: Label
@export var time: Label

func _ready() -> void:
	score.text = "MOVES:\n" + str(GlobalVariables.moves_this_run)
	highscore.text = "SCORE:\n" + str(GlobalVariables.score)
	time.text = "TIME:\n" + str(GlobalVariables.time)
