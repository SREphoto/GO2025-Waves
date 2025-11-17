class_name GameVariables
extends Node2D

@export var sand_tile_map_layer: SandTileMapLayer
@export var score_manager: ScoreManager
@export var wave_manager: WaveManager

@export var all_goals: Array[int] 		= [20, 50, 120, 240]
@export var all_round_waves: Array[int] = [2, 3, 4, 5]

@export var wave_time : int = 1000:
	set(value):
		wave_time = value
		remaining_time = wave_time

@onready var second_timer: Timer = $SecondTimer

var current_goal : int
var current_score : int = 0
var remaining_waves : int
var remaining_time : int = wave_time

var active: bool = true:
	set = on_active

var has_finished: bool = false

signal values_changed
signal counting_finished(won: bool)

func _ready() -> void:
	current_goal = all_goals.pop_front()
	remaining_waves = all_round_waves.pop_front()
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

func on_wave_finished() -> void:
	current_goal -= current_score
	current_score = 0
	remaining_waves -= 1
	# If higher score than needed
	if current_goal <= 0:
		GlobalVariables.money += abs(current_goal)
		current_goal = 0
	# If all waves are completed
	if remaining_waves <= 0:
		if current_goal <= 0:
			has_finished = true
			_won()
		else:
			_lost()
	values_changed.emit()
	
	second_timer.stop()
	
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await  timer.timeout
	counting_finished.emit(has_finished)
	
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
	GlobalGameState.state = GlobalGameState.STATES.GAMEOVER

func next_game() -> void:
	has_finished = false
	sand_tile_map_layer.increase_grid_size()
	if all_goals.is_empty():
		game_finished()
		return
	current_goal = all_goals.pop_front()
	remaining_waves = all_round_waves.pop_front()
	values_changed.emit()

func game_finished() -> void:
	pass
