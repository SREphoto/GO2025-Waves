extends Sprite2D

const hat_threshold = 0.5

static var available_hats = [
	0, 1, 2, 3, 4, 5, 6, 7
]

func _ready() -> void:
	if randf() > hat_threshold:
		var hat_category = available_hats.pick_random()
		var x_pos = randi_range(0, 2)
		frame_coords = Vector2(x_pos, hat_category)
	else:
		visible = false
