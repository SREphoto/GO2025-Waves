class_name ExplosionGrid
extends Node2D

@export var house_manager: HouseManager
@export var sand_tilemap_layer : SandTileMapLayer
@export var poseidon : Poseidon

const EXPLOSION = preload("uid://f3vy1pxarxxl")

func explode_grid():
	poseidon.attacking = true
	var columns = {}
	
	for pos in sand_tilemap_layer.all_pos:
		var x := int(pos.x)
		if x not in columns:
			columns[x] = []
		columns[x].append(pos)
	
	var sorted_keys := columns.keys()
	sorted_keys.sort()
	
	for key in sorted_keys:
		var column = columns[key]
		await get_tree().create_timer(0.2).timeout
		for pos in column:
			var global_pos = pos * GlobalVariables.GRID_SIZE + Vector2i(16, 16)
			var explosion = EXPLOSION.instantiate()
			add_child(explosion)
			explosion.position = global_pos
			explosion.explode(0.0)
			if house_manager.house_on_pos(pos):
				var house: House = house_manager.get_house_on_pos(pos)
				house.destroy()
