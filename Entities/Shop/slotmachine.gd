class_name SlotMachine
extends Sprite2D

@export var shop : Shop

@onready var shaft: Sprite2D = $Shaft
@onready var knob: Sprite2D = $Knob
@onready var pull_player: AnimationPlayer = $PullPlayer

const MAX_DRAG: float = 300.0
const MIN_DRAG_TO_TRIGGER: float = 80.0

var drag_start_y: float = 0.0
var dragging: bool = false
var drag_valid: bool = false

func _ready() -> void:
	reset_slot()

func _input(event: InputEvent) -> void:
	if not shop.active:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# mouse pressed
		if event.pressed:
			drag_valid = _clicked_knob(event.position)
			
			if drag_valid:
				MouseManager.set_grab()
				dragging = true
				drag_start_y = event.position.y
				pull_player.pause()
		else:
			# Mouse released
			if dragging:
				_finish_drag()
			MouseManager.set_hover()
			dragging = false
			drag_valid = false
	# apply drag
	elif dragging and drag_valid and event is InputEventMouseMotion:
		var dy: float = max(event.position.y - drag_start_y, 0.0)
		var t: float = clamp(dy / MAX_DRAG, 0.0, 0.95)
		pull_player.seek(t * pull_player.current_animation_length, true)

func _clicked_knob(mouse_pos: Vector2) -> bool:
	var rect := knob.get_rect()
	var global_rect := rect
	global_rect.position = knob.to_global(rect.position)
	global_rect.size = rect.size * knob.global_scale
	return global_rect.has_point(mouse_pos)

func _finish_drag() -> void:
	var dy = max(get_viewport().get_mouse_position().y - drag_start_y, 0.0)

	if dy < MIN_DRAG_TO_TRIGGER:
		# Not pulled far enough → rewind to start
		pull_player.seek(0.0, true)
		pull_player.pause()
	else:
		# Valid pull → play forward
		pull_player.play()

func squish():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", Vector2(5.0, 4.0), 0.2)
	tween.tween_property(self, "scale", Vector2(4.2, 4.8), 0.2)
	tween.tween_property(self, "scale", Vector2(4.5, 4.5), 0.2)

func reset_slot():
	pull_player.seek(0.0, true)
	pull_player.play("Pull")
	pull_player.pause()

func stop_spinning():
	shop.active = false
	SoundManager.slot_audio_manager.play_lever()
	squish()
	await get_tree().create_timer(0.5).timeout
	shop.stop_spinning()
