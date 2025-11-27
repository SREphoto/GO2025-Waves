class_name Poseidon
extends StaticBody2D

@export var sand_tile_map_layer: SandTileMapLayer

@onready var animated_sprite: AnimatedSprite2D = $Poseidon

var angry = false
var attacking = false
var is_animating = false

var click_count = 0

signal poseidon_pressed

func _ready() -> void:
	sand_tile_map_layer.changed_grid_size.connect(on_grid_size_changed)
	input_event.connect(_on_input_event)

func _process(_delta: float) -> void:
	_animate()

func on_grid_size_changed() -> void:
	var bound: Vector4 = sand_tile_map_layer.get_grid_bounds()
	var target_pos: Vector2
	target_pos.x = ((bound.x * 1.5) - 0.5) * GlobalVariables.GRID_SIZE
	target_pos.y = posmod(int(sand_tile_map_layer.grid_size.y), 2) * -(float(GlobalVariables.GRID_SIZE)/2) + 32
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.8)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and not angry:
		if click_count >= 2:
			click_count = 0
			poseidon_pressed.emit()
		else:
			SoundManager.voice_manager.poseidon_voice_player.play()
			angry = true
			click_count += 1
			await get_tree().create_timer(1.0).timeout
			angry = false

func _animate():
	if attacking:
		if not is_animating:
			is_animating = true
			var attack_anim = "Atk1" if randf() > 0.5 else "Atk2"
			animated_sprite.play(attack_anim)
			await animated_sprite.animation_finished
			is_animating = false
	elif angry:
		if not is_animating:
			is_animating = true
			var angry_anim = "Angry1" if randf() > 0.5 else "Angry2"
			animated_sprite.play(angry_anim)
			await animated_sprite.animation_finished
			is_animating = false
	else:
		if animated_sprite.animation != "Idle":
			animated_sprite.play("Idle")
		is_animating = false
