class_name TutorialUI
extends CanvasLayer

@export var game: Game
@export var game_vars : GameVariables
@export var score_manager : ScoreManager
@export var selector : Selector
@export var wave_manager : WaveManager
@export var shop : Shop
@export var hoverer: Hoverer

@onready var tutorial_dialogue: Node = $TutorialDialogue
@onready var mayor: MayorIcon = $Control/Mayor
@onready var speech_bubble: SpeechBubble = $Control/SpeechBubble
@onready var pointer_sprite: Sprite2D = $PointerSprite
@onready var click_catching_rect: ColorRect = $ClickCatchingRect

var running: bool = false

var received_signals = {
	"house_grabbed" : false,
	"house_moved" : false,
	"wave_sent" : false,
	"wave_finished" : false,
	"shopping_done" : false,
}

signal dict_value_changed

func _ready() -> void:
	initalize()
	if GlobalVariables.first_time:
		await get_tree().create_timer(0.5).timeout
		dialogue_loop_tut(tutorial_dialogue.dialogue_tut)
	if GlobalVariables.first_time_multi:
		await shop.shop_entered
		dialogue_loop_tut(tutorial_dialogue.dialogue_multi)

func initalize():
	mayor.reset()
	pointer_sprite.reset()
	if score_manager:
		score_manager.biggest_color_groups_changed.connect(_on_house_moved)
	if game_vars:
		game_vars.wave_finished.connect(_on_wave_finished)
	if selector:
		selector.object_selected.connect(_on_object_selected)
	if wave_manager:
		wave_manager.send_wave.connect(_on_wave_sent)
	if shop:
		shop.shopping_done.connect(_on_shopping_done)

#region signals
func _on_wave_finished():
	set_signal_value("wave_finished", true)

func _on_object_selected(_object):
	set_signal_value("house_grabbed", true)

func _on_house_moved():
	await get_tree().process_frame
	if not received_signals["house_moved"]:
		pointer_sprite.disappear()
	if game_vars.current_score > 0 and received_signals["house_grabbed"]:
		set_signal_value("house_moved", true)

func _on_wave_sent():
	set_signal_value("wave_sent", true)

func _on_shopping_done(_object):
	set_signal_value("shopping_done", true)
#endregion

func set_signal_value(key: String, value):
	if key in received_signals:
		received_signals[key] = value
		dict_value_changed.emit()

func dialogue_loop_tut(dialogue_arr : Array):
	running = true
	mayor.appear()
	await get_tree().create_timer(0.5).timeout
	for dialogue in dialogue_arr:
		var _speaker = dialogue["speaker"]
		var mood = dialogue["mood"]
		var dir = dialogue["direction"]
		var text = dialogue["text"]
		var has_skip = dialogue["has_skip"]
		var required_signal = dialogue["signal_listen"]
		var emitted_signal = dialogue["signal_emit"]
		var pointer = dialogue["pointer"]
		var pointer_rotation = dialogue["pointer_rotation"]
		
		mayor.play(mood)
		
		# If no_skip, check signals
		# If this has already been done, add a skip button!
		if not has_skip:
			if received_signals[required_signal] == true:
				has_skip = true
		
		# disable all other input when a skip button is here
		click_catching_rect.visible = has_skip
		
		speech_bubble.set_bubble(text, has_skip, dir)
		await speech_bubble.appear()
		
		if pointer:
			var tween: Tween = create_tween()
			tween.tween_property(pointer_sprite, "position", pointer, 0.5)
			tween.parallel().tween_property(pointer_sprite, "rotation_degrees", pointer_rotation, 0.5)
			#pointer_sprite.position = pointer
			#pointer_sprite.rotation_degrees = pointer_rotation
			pointer_sprite.appear()
		
		hoverer.active = false
		selector.active = false
		game.start_wave_active = false
		if emitted_signal != null:
			emitted_singals(emitted_signal)
		if has_skip:
			await speech_bubble.skip_pressed
			pointer_sprite.disappear()
		else:
			while true:
				# If a dict value has changed, check if it is the right value,
				# if yes then skip
				await dict_value_changed
				if received_signals[required_signal] == true:
					pointer_sprite.disappear()
					break
		await speech_bubble.disappear()
	mayor.disappear()
	hoverer.active = true
	selector.active = true
	game.start_wave_active = true
	click_catching_rect.visible = false
	running = false
	game_vars.active = true

func emitted_singals(emitted: String) -> void:
	match emitted:
		"house_movable":
			hoverer.active = true
			selector.active = true
		"start_wave_pressable":
			game.start_wave_active = true
		_:
			pass
