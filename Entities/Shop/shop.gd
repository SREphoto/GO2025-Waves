class_name Shop
extends CanvasLayer

@export var game_variables: GameVariables

@onready var money_label: RichTextLabel = $ColorRect/M/M/V/MoneyLabel

func enter() -> void:
	visible = true
	var money: int = game_variables.money
	money_label.text = " $" + str(money)

func exit() -> void:
	visible = false
