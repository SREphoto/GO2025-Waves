@tool
class_name ZoomCamera
extends Camera2D

@export var sand_tile_map_layer: SandTileMapLayer

var viewport_size_y: int = 1080

var zoom_to: float = 5.625

func _ready() -> void:
	if GlobalVariables.hard_mode:
		offset = Vector2(0, -384)
	else:
		offset = Vector2(-384, 0)
	sand_tile_map_layer.changed_grid_size.connect(_on_changed_grid_size)
	if not Engine.is_editor_hint():
		viewport_size_y = int(get_viewport_rect().size.y)
	_on_changed_grid_size()

func _on_changed_grid_size() -> void:
	zoom_to = (viewport_size_y / ((sand_tile_map_layer.grid_size.y + 2) * GlobalVariables.GRID_SIZE))
	if GlobalGameState.last_round:
		zoom_to -= 0.4
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT).tween_property(self, "zoom", Vector2(zoom_to, zoom_to), 0.5)
		
	var pos_x: float = fmod(sand_tile_map_layer.grid_size.x, 2)
	var pos_y: float = fmod(sand_tile_map_layer.grid_size.y, 2)
	var pos_vec: Vector2 = Vector2(-pos_x * GlobalVariables.GRID_SIZE/2, -pos_y * GlobalVariables.GRID_SIZE/2)
	tween.parallel().set_trans(Tween.TRANS_QUINT).tween_property(self, "position", pos_vec, 0.5)
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished() -> void:
	sand_tile_map_layer.set_tilemap()
	sand_tile_map_layer.set_all_pos()
