class_name GameVariables
extends Node2D

@export var zoom_camera: ZoomCamera
@export var sand_tile_map_layer: SandTileMapLayer
@export var score_manager: ScoreManager
@export var wave_manager: WaveManager
@export var ui: UI
@export var tutorial_ui: TutorialUI
@export var game: Game
@export var clock: Clock
@export var poseidon : Poseidon
@onready var little_guy_spawner: LittleGuySpawner = $"../LittleGuySpawner"

@export var all_goals: Array[int] 		= [10, 20, 46, 98, 160, 800]
@export var all_round_waves: Array[int] = [2, 2, 2, 2, 2, 5]

@export var hard_mode_all_goals: Array[int] 		= [14, 26, 49, 130, 220, 1000]
@export var hard_mode_all_round_waves: Array[int] = [2, 2, 2, 2, 2, 5]

@onready var explosion_grid: ExplosionGrid = $"../ExplosionGrid"

@export var wave_time : int = 180:
	set(value):
		wave_time = value
		remaining_time = wave_time

@onready var second_timer: Timer = $SecondTimer

var current_goal : int
var current_score : int = 0
var remaining_waves : int
var remaining_time : int = wave_time

var current_wave: int =  0

var active: bool = true:
	set = on_active

var has_finished: bool = false

var lost: bool = false

signal values_changed
signal counting_finished(won: bool)

signal wave_finished()

signal no_time()

func _ready() -> void:
	score_manager.score_changed.connect(on_score_changed)
	wave_manager.finished_waves.connect(on_wave_finished)
	next_game()

func on_active(value: bool) -> void:
	if tutorial_ui.running:
		return
	active = value
	if active:
		second_timer.start()
	else:
		second_timer.stop()

func on_wave_finished() -> void:
	current_wave += 1
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
			current_wave = 0
			_won()
		else:
			has_finished = true
			current_wave = 0
			_lost()
	second_timer.stop()
	
	_house_counting()
	
	_prepare_new_wave()
	
	wave_finished.emit()

func _prepare_new_wave():
	remaining_time = wave_time

func on_score_changed() -> void:
	current_score = score_manager.calculate_score()
	values_changed.emit()

func _on_second_passed() -> void:
	remaining_time -= 1
	values_changed.emit()
	if remaining_time == 60:
		clock.play_ticks()
	if remaining_time < 0:
		no_time.emit()

func _won() -> void:
	GlobalVariables.bosses_completed_now += 1

func _lost() -> void:
	lost = true

func next_game() -> void:
	has_finished = false
	if game.current_round == (game.last_round + 1):
		game_finished()
		return
	if lost:
		game_over()
		return
	if posmod(game.current_round, 2) == 1:
		sand_tile_map_layer.increase_grid_size()
	if GlobalVariables.hard_mode:
		current_goal = hard_mode_all_goals[game.current_round]
		remaining_waves = hard_mode_all_round_waves[game.current_round]
	else:
		current_goal = all_goals[game.current_round]
		remaining_waves = all_round_waves[game.current_round]
		if GlobalVariables.first_time:
			remaining_waves += 1
	values_changed.emit()

func _house_counting() -> void:
	await get_tree().create_timer(0.4).timeout
	for group in score_manager.biggest_color_groups:
		await get_tree().create_timer(0.4).timeout
		for house in group:
			SoundManager.rising_pop_player.play_rising()
			await _count_house(house)
	
	values_changed.emit()
	SoundManager.rising_pop_player.reset_pitch()
	
	if GlobalGameState.last_round:
		if current_wave == 4:
			sand_tile_map_layer.decrease_grid_size()
		if current_goal == 0:
			game_finished()
			return
	
	counting_finished.emit(has_finished)

func _count_house(house: House) -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(house, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_property(house, "scale", Vector2(1, 1), 0.1)
	await tween.finished

func game_over() -> void:
	SoundManager.voice_manager.stop_voices()
	MusicManager.ambience_player.stop()
	
	RainLayer.fade_out()
	
	await ui.blend_out()
	
	MusicManager.switch_music("GAMEOVER")
	
	little_guy_spawner.panic()
	explosion_grid.explode_grid()
	await get_tree().create_timer(1.5).timeout
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(zoom_camera, "position", Vector2(0, 320.0), 2)
	tween.parallel().tween_property(zoom_camera, "zoom", Vector2(5.625, 5.625), 1.8)
	
	await tween.finished
	
	GlobalVariables.moves_total += GlobalVariables.moves_this_run
	GlobalGameState.state = GlobalGameState.STATES.GAMEOVER

func game_finished() -> void:
	
	GlobalVariables.moves_total += GlobalVariables.moves_this_run
	
	await get_tree().create_timer(0.4).timeout
	poseidon.explode()
	await get_tree().create_timer(1.2).timeout
	ui.blend_out()
	SoundManager.voice_manager.stop_voices()
	MusicManager.switch_music("WIN")
	RainLayer.fade_out_rain()
	GlobalBoat.tween_boat()
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(zoom_camera, "position:y", 320.0, 4)
	tween.parallel().tween_property(zoom_camera, "position:x", 0, 3.8)
	tween.parallel().tween_property(zoom_camera, "zoom", Vector2(4.0, 4.0), 3.8)
	
	await tween.finished
	
	SceneSwitcher.switch_game_to_win()
