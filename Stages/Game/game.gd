class_name Game
extends Node2D

enum GAME_STATES {SHOP, PAUSED, SPAWNING, SLIDING, WAVES, COUNTING}
var game_state: GAME_STATES
var next_game_state: GAME_STATES

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

func _ready() -> void:
	GlobalVariables.bosses_completed_now = 0
	GlobalGameState.game_scene = self
	game_variables.wave_finished.connect(on_wave_finished)
	game_variables.counting_finished.connect(on_counting_finished)
	poseidon.poseidon_pressed.connect(_switch_game_state)
	ui.start_wave.connect(_switch_game_state)
	_game_state_paused()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.waves):
		switch_game_state()

func _switch_game_state() -> void:
	switch_game_state()

func on_wave_finished() -> void:
	switch_game_state()

func on_counting_finished(has_finished: bool) -> void:
	if has_finished:
		next_game_state = GAME_STATES.SHOP
	else:
		next_game_state = GAME_STATES.SPAWNING
	switch_game_state()

func switch_game_state(value = next_game_state) -> void:
	game_state = value
	match game_state:
		GAME_STATES.SHOP:
			_game_state_shop()
		GAME_STATES.PAUSED:
			_game_state_paused()
		GAME_STATES.SPAWNING:
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
	next_game_state = GAME_STATES.SPAWNING
	GlobalGameState.state = GlobalGameState.STATES.SHOP

func _game_state_paused() -> void:
	game_variables.active = false
	ui.canvas_modulate.color = Color(1,1,1,0)
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
	house_manager._spawn_house()
	next_game_state = GAME_STATES.SLIDING
	switch_game_state()

func _game_state_sliding() -> void:
	ui.blend_in()
	game_variables.active = true
	hoverer.active = true
	shop.exit()
	selector.active = true
	next_game_state = GAME_STATES.WAVES
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.GAMELOOP

func _game_state_waves() -> void:
	game_variables.active = false
	hoverer.active = false
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
