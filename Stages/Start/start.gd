class_name Start
extends Node2D

enum GAME_STATES {PAUSED, EXPANDING, SPAWNING, SLIDING, WAVES, COUNTING}
var game_state: GAME_STATES
var next_game_state: GAME_STATES

@onready var selector: Selector = $Selector
@onready var wave_manager: WaveManager = $WaveManager

@onready var game_variables: GameVariables = $GameVariables

@onready var ui: UI = $UI
@onready var shop: CanvasLayer = $Shop

func _ready() -> void:
	_game_state_sliding()
	game_variables.counting_finished.connect(on_counting_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.waves):
		switch_game_state()

func on_counting_finished(has_won: bool) -> void:
	if has_won:
		next_game_state = GAME_STATES.PAUSED
	else:
		next_game_state = GAME_STATES.SLIDING
	_game_state_counting()

func switch_game_state(value = next_game_state) -> void:
	game_state = value
	match game_state:
		GAME_STATES.PAUSED:
			_game_state_paused()
		GAME_STATES.EXPANDING:
			_game_state_expanding()
		GAME_STATES.SPAWNING:
			_game_state_spawning()
		GAME_STATES.SLIDING:
			_game_state_sliding()
		GAME_STATES.WAVES:
			_game_state_waves()
		GAME_STATES.COUNTING: 
			_game_state_counting()

func _game_state_paused() -> void:
	ui.visible = false
	game_variables.active = false
	game_variables.next_game()
	shop.visible = true
	next_game_state = GAME_STATES.SLIDING
	GlobalGameState.state = GlobalGameState.STATES.SHOP

func _game_state_expanding() -> void:
	pass

func _game_state_spawning() -> void:
	pass

func _game_state_sliding() -> void:
	ui.visible = true
	game_variables.active = true
	shop.visible = false
	selector.active = true
	next_game_state = GAME_STATES.WAVES
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.GAMELOOP

func _game_state_waves() -> void:
	game_variables.active = false
	selector.active = false
	next_game_state = GAME_STATES.COUNTING
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.WAVE

func _game_state_counting() -> void:
	switch_game_state()
