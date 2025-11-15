class_name GameVariables
extends Node2D

@export var score_manager: ScoreManager
@export var wave_manager: WaveManager

@export var round_goal : int = 5:
	set(value):
		round_goal = value
		current_goal = round_goal
@export var round_waves : int = 2:
	set(value):
		round_waves = value
		remaining_waves = round_waves
@export var wave_time : int = 1000:
	set(value):
		wave_time = value
		remaining_time = wave_time

@onready var second_timer: Timer = $SecondTimer

var current_goal : int = round_goal:
	set(value):
		current_goal = max(0, value)
var current_score : int = 0
var remaining_waves : int = round_waves
var remaining_time : int = wave_time

var money : int = 0

var active: bool = true:
	set = on_active

signal values_changed
signal counting_finished(won: bool)

func _ready() -> void:
	score_manager.score_changed.connect(on_score_changed)
	wave_manager.finished_waves.connect(on_wave_finished)
	# So values get updated at the start
	values_changed.emit()
	second_timer.start()

func on_active(value: bool) -> void:
	active = value
	if active:
		second_timer.start()
	else:
		second_timer.stop()

func stop_timer() -> void:
	pass

func on_wave_finished() -> void:
	var has_won: bool = false
	current_goal -= current_score
	current_score = 0
	remaining_waves -= 1
	# If higher score than needed
	if current_goal <= 0:
		money += abs(current_goal)
		current_goal = 0
		has_won = true
		_won()
	# If all waves are completed
	elif remaining_waves <= 0:
		_lost()
	values_changed.emit()
	
	second_timer.stop()
	
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await  timer.timeout
	counting_finished.emit(has_won)
	
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
	remaining_time -= 1
	values_changed.emit()
	if remaining_time < 0:
		wave_manager.state_send()

func _won() -> void:
	print("WON")

func _lost() -> void:
	print("LOST")

func next_game():
	round_goal += 1
	round_waves = 2
	values_changed.emit()
