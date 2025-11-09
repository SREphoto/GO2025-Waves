class_name Start
extends Node2D

enum GAME_STATES {SPAWNING, SLIDING, WAVES, COUNTING}
var game_state: GAME_STATES:
	set = _set_game_state
	
@onready var selector: Selector = $Selector

func _ready() -> void:
	game_state = GAME_STATES.SLIDING

func _set_game_state(value) -> void:
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

func _game_state_waves() -> void:
	selector.active = false

func _game_state_counting() -> void:
	pass
