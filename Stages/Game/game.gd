class_name Game
extends Node2D

enum GAME_STATES {SHOP, PAUSED, SPAWNING, SLIDING, WAVES, COUNTING}
var game_state: GAME_STATES
var next_game_state: GAME_STATES

var current_round: int = 0

@onready var zoom_camera: ZoomCamera = $ZoomCamera
@onready var sand_tile_map_layer: SandTileMapLayer = $SandTileMapLayer
@onready var water_tile_map_layer: WaterTileMapLayer = $WaterTileMapLayer

@onready var selector: Selector = $Selector
@onready var wave_manager: WaveManager = $WaveManager
@onready var house_manager: HouseManager = $HouseManager

@onready var hoverer: Hoverer = $Hoverer

@onready var game_variables: GameVariables = $GameVariables

@onready var poseidon: Poseidon = $Poseidon

@onready var ui: UI = $UI
@onready var shop: Shop = $Shop
@onready var tutorial_ui: CanvasLayer = $TutorialUI

var start_wave_active: bool = false

func _ready() -> void:
	GlobalVariables.bosses_completed_now = 0
	GlobalGameState.game_scene = self
	game_variables.wave_finished.connect(on_wave_finished)
	game_variables.counting_finished.connect(on_counting_finished)
	game_variables.no_time.connect(switch_game_state)
	poseidon.poseidon_pressed.connect(on_start_wave)
	ui.start_wave.connect(on_start_wave)
	shop.shopping_done.connect(on_shopping_done)
	_game_state_paused()

func on_start_wave() -> void:
	if start_wave_active:
		switch_game_state()

func on_wave_finished() -> void:
	switch_game_state()

func on_counting_finished(has_finished: bool) -> void:
	if has_finished:
		next_game_state = GAME_STATES.SHOP
	else:
		next_game_state = GAME_STATES.SPAWNING
	switch_game_state()

func on_shopping_done(house_res: HouseRescource) -> void:
	if GlobalVariables.first_time_multi:
		tutorial_ui.dialogue_loop_multi()
	GlobalVariables.first_time_multi = false
	house_manager.spawn_specific_house(house_res)
	switch_game_state()

func switch_game_state(value = next_game_state) -> void:
	game_state = value
	match game_state:
		GAME_STATES.SHOP:
			SoundManager.voice_manager.start_voices()
			_game_state_shop()
		GAME_STATES.PAUSED:
			_game_state_paused()
		GAME_STATES.SPAWNING:
			SoundManager.voice_manager.start_voices()
			poseidon.attacking = false
			_game_state_spawning()
		GAME_STATES.SLIDING:
			poseidon.attacking = false
			_game_state_sliding()
		GAME_STATES.WAVES:
			poseidon.attacking = true
			_game_state_waves()
		GAME_STATES.COUNTING: 
			poseidon.attacking = false
			_game_state_counting()

func _game_state_shop() -> void:
	ui.blend_out()
	game_variables.active = false
	game_variables.next_game()
	hoverer.active = false
	shop.enter()
	next_game_state = GAME_STATES.SLIDING
	GlobalGameState.state = GlobalGameState.STATES.SHOP

func _game_state_paused() -> void:
	game_variables.active = false
	ui.canvas_modulate.color = Color(1,1,1,0)
	start_wave_active = false
	selector.active = false
	hoverer.active = false
	shop.exit()
	next_game_state = GAME_STATES.SLIDING
	GlobalGameState.state = GlobalGameState.STATES.GAMELOOP
	
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_IN).tween_property(zoom_camera, "offset", Vector2(0,0), 0.25)
	
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(3)
	await timer.timeout
	switch_game_state()

func _game_state_spawning() -> void:
	if not GlobalVariables.first_time:
		current_round += 1
	house_manager.spawn_special_or_random_house(current_round)
	next_game_state = GAME_STATES.SLIDING
	if GlobalVariables.first_time == true:
		GlobalVariables.first_time = false
	switch_game_state()

func _game_state_sliding() -> void:
	ui.blend_in()
	game_variables.active = true
	hoverer.active = true
	shop.exit()
	if GlobalVariables.first_time:
		start_wave_active = false
		selector.active = false
	else:
		start_wave_active = true
		selector.active = true
	next_game_state = GAME_STATES.WAVES
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.GAMELOOP

func _game_state_waves() -> void:
	game_variables.active = false
	hoverer.active = false
	start_wave_active = false
	selector.active = false
	next_game_state = GAME_STATES.COUNTING
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.WAVE

func _game_state_counting() -> void:
	if next_game_state == GAME_STATES.COUNTING:
		next_game_state = GAME_STATES.SPAWNING
	MusicManager.switch_music("SHOP")

func get_camera() -> ZoomCamera:
	return zoom_camera

func get_sand() -> SandTileMapLayer:
	return sand_tile_map_layer

func get_water() -> WaterTileMapLayer:
	return water_tile_map_layer

func get_nav_region() -> NavigationRegion:
	return find_child("NavigationRegion")
