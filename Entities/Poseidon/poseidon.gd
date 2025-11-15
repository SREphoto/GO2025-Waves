class_name Poseidon
extends StaticBody2D

@export var sand_tile_map_layer: SandTileMapLayer

signal poseidon_pressed

func _ready() -> void:
	sand_tile_map_layer.changed_grid_size.connect(on_grid_size_changed)
	input_event.connect(_on_input_event)

func on_grid_size_changed() -> void:
	var bound: Vector4 = sand_tile_map_layer.get_grid_bounds()
	var target_pos: Vector2
	target_pos.x = ((bound.x * 1.5) - 0.5) * GlobalConfigs.GRID_SIZE
	target_pos.y = posmod(int(sand_tile_map_layer.grid_size.y), 2) * -(float(GlobalConfigs.GRID_SIZE)/2)
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.8)

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		poseidon_pressed.emit()
