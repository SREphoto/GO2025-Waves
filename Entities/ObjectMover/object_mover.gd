class_name ObjectMover
extends Node2D

@onready var rays: Node2D = %Rays

@onready var ghosts: Node2D = $Ghosts
@onready var ghost_object: Sprite2D = $Ghosts/GhostObject
@onready var ghost_back: Sprite2D = $Ghosts/GhostBack

var object_to_move: MovableGridObject:
	set = set_object_to_move
var mouse_outside_of_object: bool = false

var last_mouse_dir: Vector2i
var current_dir_str : String
var target_pos: Vector2

var shortest_rays: Dictionary[String, CheckRay] = {}

var locked: bool = false

var mouse_pressed_pos: Vector2

const DIRECTIONS: Array[Vector2i] = [Vector2i.LEFT, Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN]
const DIR_NAMES: Dictionary[Vector2i, String] = {Vector2i.LEFT : "Left", Vector2i.UP : "Up", Vector2i.RIGHT : "Right", Vector2i.DOWN : "Down"}

const CHECK_RAY = preload("uid://cf7275hbjmdnq")

signal object_move_finished()

func set_object_to_move(value) -> void:
	object_to_move = value
	global_position = object_to_move.position
	#object_to_move.selectable.mouse_exited.connect(_on_object_to_move_mouse_exited)
	#object_to_move.selectable.mouse_entered.connect(_on_object_to_move_mouse_entered)
	await ready
	var house = object_to_move as House
	if is_instance_valid(house):
		ghosts.modulate.a = 0.0 # Hide the ghost on default
		ghost_object.texture = house.front.texture
		ghost_object.hframes = house.front.hframes
		ghost_object.frame = house.front.frame
		if house.res.frame_back:
			ghost_back.frame = house.back.frame
			ghost_back.visible = true
		else:
			ghost_back.visible = false
		ghost_object.position = house.front.position
		ghost_object.position.y += 4
	_create_raycasts()
	_expand_raycasts()
	mouse_pressed_pos = get_global_mouse_position()

func _create_raycasts() -> void:
	for size_pos: Vector2i in object_to_move.size:
		for dir in DIRECTIONS:
			var pos = size_pos + dir
			if not object_to_move.size.has(pos):
				var check_ray: CheckRay = CHECK_RAY.instantiate()
				check_ray.set_grid_pos(pos)
				var ray_dir: Node2D = rays.find_child(DIR_NAMES.get(dir))
				ray_dir.add_child(check_ray)

func _expand_raycasts() -> void:
	for ray_dir: Node2D in rays.get_children():
		var dir: Vector2i = DIR_NAMES.find_key(ray_dir.name)
		var shortest: CheckRay = ray_dir.get_child(0)
		for ray: CheckRay in ray_dir.get_children():
			ray.target_position.x = 0
			ray.force_raycast_update()
			while not ray.is_colliding():
				ray.target_position += Vector2(dir * 32)
				ray.force_raycast_update()
			if ray.target_position.length_squared() < shortest.target_position.length_squared():
				shortest = ray
		shortest_rays.get_or_add(ray_dir.name, shortest)

func _ghost_push(dir: String) -> void:
	var ray: CheckRay = shortest_rays.get(dir)
	if ray.target_position.is_zero_approx():
		_ghost_hide()
		return
	else:
		_ghost_show()
	target_pos = global_position + ray.target_position
	_tween_ghost_to_pos()

func _ghost_reset() -> void:
	_ghost_hide()
	target_pos = global_position
	_tween_ghost_to_pos()

func _ghost_show() -> void:
	var tween = create_tween()
	tween.tween_property(ghosts, "modulate:a", 1.0, 0.2)

func _ghost_hide() -> void:
	var tween = create_tween()
	tween.tween_property(ghosts, "modulate:a", 0.0, 0.2)

func _tween_ghost_to_pos() -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUINT).tween_property(ghosts, "global_position", target_pos, 0.2)

func _input(_event: InputEvent) -> void:
	if locked:
		return
	
	var mouse_dir: Vector2i = _get_vector_cardinal_dir(get_global_mouse_position())
	if last_mouse_dir != mouse_dir:
		#if mouse_outside_of_object:
		if _get_mouse_distance() > 8:
			last_mouse_dir = mouse_dir
			match mouse_dir:
				Vector2i.LEFT:
					current_dir_str = "Left"
				Vector2i.UP:
					current_dir_str = "Up"
				Vector2i.RIGHT:
					current_dir_str = "Right"
				Vector2i.DOWN:
					current_dir_str = "Down"
			_ghost_push(current_dir_str)
		elif last_mouse_dir != Vector2i.ZERO:
			last_mouse_dir = Vector2i.ZERO
			_ghost_reset()

func _get_vector_cardinal_dir(vec: Vector2) -> Vector2i:
	var dir: Vector2 = vec - mouse_pressed_pos #(global_position + object_to_move.mid_pos)
	if abs(dir.x) < abs(dir.y):
		dir.x = 0
		dir = dir.normalized()
	else:
		dir.y = 0
		dir = dir.normalized()
		
	return dir

func _get_mouse_distance() -> float:
	var dist: float = abs((mouse_pressed_pos - get_global_mouse_position()).length())
	return dist

func object_deselected() -> void:
	locked = true
	if target_pos != Vector2.ZERO:
		_move_grid_object()
	else:
		queue_free()

func _move_grid_object() -> void:
	var tween = create_tween()
	SoundManager.swipe_house_player.play()
	tween.set_trans(Tween.TRANS_QUINT).tween_property(object_to_move, "global_position", target_pos, 0.2)
	object_to_move.squish(current_dir_str)
	await tween.finished
	object_move_finished.emit()
	queue_free()

func _on_object_to_move_mouse_exited() -> void:
	mouse_outside_of_object = true

func _on_object_to_move_mouse_entered() -> void:
	mouse_outside_of_object = false
