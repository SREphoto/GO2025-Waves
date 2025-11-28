class_name EndScoreSetter
extends Node2D

@export var score: Label
@export var highscore: Label
@export var time: Label

func _ready() -> void:
	score.text = "SCORE:\n" + str(GlobalVariables.moves_this_run)
