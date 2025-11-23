extends CanvasLayer

@export var game_vars : GameVariables
@export var score_manager : ScoreManager

@onready var tutorial_dialogue: Node = $TutorialDialogue
@onready var major_icon: AnimatedSprite2D = $Control/MajorIcon
@onready var speech_bubble: Sprite2D = $Control/SpeechBubble

var received_signals = {
	"house_moved" : false,
	"wave_finished" : false
}

signal dict_value_changed

func _ready() -> void:
	initalize()
	dialogue_loop()

func initalize():
	if score_manager:
		score_manager.biggest_color_groups_changed.connect(_on_house_moved)
	if game_vars:
		game_vars.wave_finished.connect(_on_wave_finished)

func set_signal_value(key: String, value):
	if key in received_signals:
		received_signals[key] = value
		dict_value_changed.emit()

func dialogue_loop():
	for dialogue in tutorial_dialogue.dialogue:
		var speaker = dialogue["speaker"]
		var mood = dialogue["mood"]
		var dir = dialogue["direction"]
		var text = dialogue["text"]
		var has_skip = dialogue["has_skip"]
		var required_signal = dialogue["signal"]
		
		# If no_skip, check signals
		# If this has already been done, add a skip button!
		if not has_skip:
			if received_signals[required_signal] == true:
				has_skip = true
		
		speech_bubble.set_bubble(text, has_skip, dir)
		await speech_bubble.appear()
		if has_skip:
			await speech_bubble.skip_pressed
		else:
			while true:
				# If a dict value has changed, check if it is the right value,
				# if yes then skip
				await dict_value_changed
				if received_signals[required_signal] == true:
					break
		await speech_bubble.disappear()

func _on_wave_finished():
	set_signal_value("wave_finished", true)

func _on_house_moved():
	set_signal_value("house_moved", true)
