class_name House
extends StaticBody2D

@onready var rays: Node2D = $Rays

@onready var ghosts: Node2D = $Ghosts


var selected: bool = false:
	set(value):
		selected = value
		house_selected.emit(self)
		if selected:
			_expand_rays()
		else:
			_collapse_rays()
var index: int

var target_pos: Vector2

signal house_selected(house: House)

func _on_pick_collider_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		selected = true
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click") and selected:
		var mouse_dir = get_global_mouse_position() - global_position
		if abs(mouse_dir.length()) > 16:
			var mouse_dir_angle = rad_to_deg(mouse_dir.angle())
			if (mouse_dir_angle > 135 and mouse_dir_angle < 180) or (mouse_dir_angle < -135 and mouse_dir_angle > -180) :
				_push("Left")
			if mouse_dir_angle > -135 and mouse_dir_angle < -45 :
				_push("Up")
			if mouse_dir_angle > -45 and mouse_dir_angle < 45 :
				_push("Right")
			if mouse_dir_angle > 45 and mouse_dir_angle < 135 :
				_push("Down")
			selected = false
			_ghost_reset(target_pos)
		else:
			selected = false

func _expand_rays() -> void:
	for ray: RayCast2D in rays.get_children():
		ray.target_position.x = 0
		while not ray.is_colliding():
			ray.target_position.x -= 32
			ray.force_raycast_update()

func _collapse_rays() -> void:
	for ray: RayCast2D in rays.get_children():
		ray.target_position.x = 0

func _push(dir: String) -> void:
	var ray: RayCast2D = rays.find_child(dir + "Ray")
	target_pos = global_position + (ray.target_position.rotated(ray.rotation))
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(self, "global_position", target_pos, 0.05)

func _ghost_push(dir: String) -> void:
	var ray: RayCast2D = rays.find_child(dir + "Ray")
	target_pos = global_position + (ray.target_position.rotated(ray.rotation))
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(ghosts, "global_position", target_pos, 0.05)

func _ghost_reset(pos: Vector2) -> void:
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_CUBIC).tween_property(ghosts, "global_position", pos, 0.05)

func _process(_delta: float) -> void:
	if selected:
		var mouse_dir = get_global_mouse_position() - global_position
		if abs(mouse_dir.length()) > 16:
			var mouse_dir_angle = rad_to_deg(mouse_dir.angle())
			if (mouse_dir_angle > 135 and mouse_dir_angle < 180) or (mouse_dir_angle < -135 and mouse_dir_angle > -180) :
				_ghost_push("Left")
			if mouse_dir_angle > -135 and mouse_dir_angle < -45 :
				_ghost_push("Up")
			if mouse_dir_angle > -45 and mouse_dir_angle < 45 :
				_ghost_push("Right")
			if mouse_dir_angle > 45 and mouse_dir_angle < 135 :
				_ghost_push("Down")
		else:
			_ghost_reset(global_position)
