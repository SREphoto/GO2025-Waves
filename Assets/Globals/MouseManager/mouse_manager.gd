extends Node2D

var cursor_hover_texture : Texture2D = preload("uid://dgwwy1n1y556x")
var cursor_grab_texture : Texture2D = preload("uid://cxngbk4cupxyq")
var cursor_point_texture : Texture2D = preload("uid://ds6hkt4qjy61d")

var cursor_hover : Image = cursor_hover_texture.get_image()
var cursor_grab : Image = cursor_grab_texture.get_image()
var cursor_point: Image = cursor_point_texture.get_image()

var current_scale: int = 2

var last_window_size := Vector2.ZERO

var last_cursor : Callable = Callable(self, "set_hover")

func _process(_delta: float) -> void:
	var window_size: Vector2 = get_window().size
	if window_size != last_window_size:
		last_window_size = window_size
		changes_screen_res()

func changes_screen_res() -> void:
	var window_ref: Vector2 = get_window().content_scale_size
	var window_size: Vector2 = get_window().size
	var window_scale_ref: Vector2 = window_size / window_ref
	var window_scale: float = min(window_scale_ref.x, window_scale_ref.y) / 4
	#var screen_scale: float = get_screen_transform().get_scale().x
	var screen_scale : float = 5.625
	current_scale = ceil(window_scale * screen_scale)
	cursor_hover.resize(current_scale * 16, current_scale * 16, Image.INTERPOLATE_NEAREST)
	cursor_grab.resize(current_scale * 16, current_scale * 16, Image.INTERPOLATE_NEAREST)
	cursor_point.resize(current_scale * 16, current_scale * 16, Image.INTERPOLATE_NEAREST)
	
	last_cursor.call()

func set_hover():
	Input.set_custom_mouse_cursor(cursor_hover, Input.CURSOR_ARROW, Vector2(7, 3) * current_scale)
	last_cursor = Callable(self, "set_hover")

func set_grab():
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_ARROW, Vector2(7, 3) *  current_scale)
	last_cursor = Callable(self, "set_grab")

func set_point():
	Input.set_custom_mouse_cursor(cursor_point, Input.CURSOR_ARROW, Vector2(5.5, 2.5) *  current_scale)
	last_cursor = Callable(self, "set_point")
