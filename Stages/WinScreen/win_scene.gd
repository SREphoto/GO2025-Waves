extends Node2D

@onready var houses: Node2D = $GridObjects/Houses

@onready var click_catching_rect: ColorRect = $CanvasLayer/ClickCatchingRect
@onready var mayor: MayorIcon = $CanvasLayer/Control/Mayor
@onready var speech_bubble: SpeechBubble = $CanvasLayer/Control/SpeechBubble
@onready var tutorial_dialogue: Node = $TutorialDialogue

@onready var follow_camera: FollowCamera = $FollowCamera
@onready var drag_screen: DragScreen = $DragScreen

@onready var youdidit: Label = $V/Youdidit
@onready var hard_mode: Label = $V/HardMode

var running = false

func _ready() -> void:
	hard_mode.visible = false
	if not GlobalVariables.hard_mode_unlocked:
		GlobalVariables.hard_mode_unlocked = true
		hard_mode.visible = true
	if GlobalVariables.hard_mode:
		youdidit.text = "You defeated the King of the Sea and saved Tidal Town!"
	else:
		youdidit.text = "You defeated the King of the Sea and saved Tidal Town!"
	drag_screen.dragged.connect(_on_screen_dragged)
	hide_flags()
	mayor.reset()
	await follow_camera.move_to_win()
	dialogue_loop_tut(tutorial_dialogue.dialogue_win)

func _on_screen_dragged() -> void:
	follow_camera.move_camera_win_to_home()

func hide_flags():
	for house : House in houses.get_children():
		house.flag.visible = false

func dialogue_loop_tut(dialogue_arr : Array):
	running = true
	mayor.appear()
	await get_tree().create_timer(0.5).timeout
	for dialogue in dialogue_arr:
		var _speaker = dialogue["speaker"]
		var mood = dialogue["mood"]
		var dir = dialogue["direction"]
		var text = dialogue["text"]
		var has_skip = true
		
		mayor.play(mood)
		SoundManager.voice_manager.mayor_voice_player.play()

		click_catching_rect.visible = has_skip
		
		speech_bubble.set_bubble(text, has_skip, dir)
		await speech_bubble.appear()
		
		if has_skip:
			await speech_bubble.skip_pressed
		await speech_bubble.disappear()
	mayor.disappear()
	click_catching_rect.visible = false
	running = false
