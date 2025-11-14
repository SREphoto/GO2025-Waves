class_name GameVariables
extends Node2D

@export var score_manager: ScoreManager
@export var wave_manager: WaveManager

@export var round_goal : int = 5
@export var round_waves : int = 1
@export var wave_time : int = 10

@onready var second_timer: Timer = $SecondTimer

var current_goal : int = round_goal
var current_score : int = 0
var remaining_waves : int = round_waves
var remaining_time : int = wave_time

var money : int = 0

signal values_changed

func _ready() -> void:
	score_manager.score_changed.connect(on_score_changed)
	wave_manager.send_wave.connect(on_wave_sent)
	# So values get updated at the start
	values_changed.emit()
	second_timer.start()

func on_wave_sent() -> void:
	current_goal -= current_score
	current_score = 0
	remaining_waves -= 1
	# If higher score than needed
	if current_goal < 0:
		money += abs(current_goal)
		current_goal = 0
		next_game()
	# If all waves are completed
	if remaining_waves <= 0:
		next_game()
	values_changed.emit()
	
	_prepare_new_wave()

func _prepare_new_wave():
	remaining_time = wave_time

func on_score_changed() -> void:
	var points: int = 0
	for group: Array[House] in score_manager.biggest_color_groups:
		points += group[0].flag.current_value
	current_score = points
	values_changed.emit()

func _on_second_passed() -> void:
	return
	remaining_time -= 1
	values_changed.emit()
	if remaining_time < 0:
		wave_manager.state_send()

func next_game():
	pass
