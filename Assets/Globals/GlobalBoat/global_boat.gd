extends Node2D

@onready var boat: Sprite2D = $Boat

@export var curve: Curve

var tween: Tween
var standard_y: float

func _ready() -> void:
	set_process(false)
	#tween_boat()

func tween_boat() -> void:
	boat.position.x = -260.0
	standard_y = boat.position.y
	
	tween = create_tween()
	tween.tween_property(boat, "position:x", 260.0, 8.0)
	
	set_process(true)
	
	await tween.finished
	
	set_process(false)
	
func _process(_delta: float) -> void:
	var time: float = tween.get_total_elapsed_time()
	
	boat.position.y = standard_y + curve.sample_baked(time)
