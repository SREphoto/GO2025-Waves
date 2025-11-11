@tool
class_name HouseToRes
extends Node2D

@export_category("Actions")
@export_tool_button("Save") var save_btn = _save

@export_category("Inputs")
@export var house: House
@export var res_name: StringName

var res: HouseRescource = HouseRescource.new()

var dir = DirAccess.open("res://Entities/GridObject/MovableGridObject/House/Resource/SavedResources/")

func _save() -> void:
	if not res_name:
		push_warning("No Res Name")
		return
	
	print("Save")
	
	var dir_path: String = "res://Entities/GridObject/MovableGridObject/House/Resource/SavedResources/"
	var file_name: String = res_name + ".tres"
	if FileAccess.file_exists(dir_path + file_name):
		dir.remove(file_name)
	
	res.size = house.size
	res.sprite_offset = house.front.position
	res.sprite_sheet = house.front.texture
	res.hframes = house.front.hframes
	res.frame = house.front.frame
	res.sel_poly = house.sel_coll_poly.polygon
	res.stat_poly = house.stat_coll_poly.polygon
	res.flag_pos = house.flag.position
	
	ResourceSaver.save(res, dir_path + file_name)
