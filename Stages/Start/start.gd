class_name Start
extends Node2D

enum GAME_STATES {SPAWNING, SLIDING, WAVES, COUNTING}
var game_state: GAME_STATES
var next_game_state: GAME_STATES

@onready var selector: Selector = $Selector
@onready var wave_manager: WaveManager = $WaveManager

func _ready() -> void:
	_game_state_sliding()
	wave_manager.finished_waves.connect(on_wave_finished)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed(GlobalNames.inputs.waves):
		switch_game_state()

func on_wave_finished() -> void:
	switch_game_state()

func switch_game_state(value = next_game_state) -> void:
	game_state = value
	match game_state:
		GAME_STATES.SPAWNING:
			_game_state_spawning()
		GAME_STATES.SLIDING:
			_game_state_sliding()
		GAME_STATES.WAVES:
			_game_state_waves()
		GAME_STATES.COUNTING: 
			_game_state_counting()

func _game_state_spawning() -> void:
	pass

func _game_state_sliding() -> void:
	selector.active = true
	next_game_state = GAME_STATES.WAVES
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.GAMELOOP

func _game_state_waves() -> void:
	selector.active = false
	next_game_state = GAME_STATES.COUNTING
	wave_manager.next_state()
	GlobalGameState.state = GlobalGameState.STATES.WAVE

func _game_state_counting() -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.start(1)
	await  timer.timeout
	next_game_state = GAME_STATES.SLIDING
	switch_game_state()
