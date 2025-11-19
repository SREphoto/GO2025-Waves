class_name HoveredTileMapLayer
extends TileMapLayer

func set_tilemap(house_group: Array[House]) -> void:
	clear()
	for house in house_group:
		var pos = house.get_grid_pos()
		for vector in house.size:
			set_cell(pos + vector, 0, Vector2(3, 3))
	set_cells_terrain_connect(get_used_cells(), 0, 0, false)

func set_tilemap_wit_pos_arr(pos_array: Array[Vector2i]) -> void:
	clear()
	for pos in pos_array:
		set_cell(pos, 0, Vector2(3, 3))
	set_cells_terrain_connect(get_used_cells(), 0, 0, false)

func clear_tilemap() -> void:
	clear()

func set_tilemap_modulate(color: Flag.COLORS) -> void:
	match color:
		Flag.COLORS.RED:
			modulate = Color("db6137")
		Flag.COLORS.GREEN:
			modulate = Color("a8c054")
		Flag.COLORS.BLUE:
			modulate = Color("6cb8d4")
		Flag.COLORS.GRAY:
			modulate = Color("c6cdcc")
