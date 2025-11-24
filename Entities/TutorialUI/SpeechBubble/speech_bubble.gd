class_name SpeechBubble
extends Sprite2D

@export var text : String = ""
@export var has_skip_button : bool = true

@onready var label: Label = $HBoxContainer/Label
@onready var skip_container: VBoxContainer = $HBoxContainer/SkipContainer
@onready var skip_button: TextureButton = $HBoxContainer/SkipContainer/SkipButton

var pos = "right"

signal skip_pressed

func _ready() -> void:
	reset()
	pass

func set_bubble(new_text : String, new_skip : bool, new_pos : String = "right"):
	self.text = new_text
	self.has_skip_button = new_skip
	self.pos = new_pos

func appear():
	reset()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale:x", 5.0, 0.2)
	tween.tween_property(self, "scale:y", 5.0, 0.4)
	await type_text_by_character()
	skip_button.visible = has_skip_button

func disappear():
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale:x", 0.0, 0.4)
	tween.tween_property(self, "scale:y", 0.0, 0.2)
	await tween.finished

func reset():
	label.text = ""
	scale = Vector2.ZERO
	skip_button.visible = false
	# Hide entire container if no skip button should ever appear!
	skip_container.visible = has_skip_button

func type_text_by_character(delay: float = 0.02):
	label.text = ""
	for character in text:
		if character == " ":
			await get_tree().create_timer(delay * 3).timeout
		label.text += character
		await get_tree().create_timer(delay).timeout

func _on_skip_button_pressed() -> void:
	skip_pressed.emit()
