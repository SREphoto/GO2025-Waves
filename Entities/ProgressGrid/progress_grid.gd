extends Node2D

@onready var statue: Node2D = $Statue
@onready var stages: Node2D = $Stages

const PROGRESS_X = preload("uid://4nu336d5a2bg")

var stage_markers : Array[Node2D] = []

func _ready() -> void:
	for child in stages.get_children():
		if child is Node2D:
			stage_markers.append(child)
	
	set_comleted_stage(9)

## How to call:
## set_completed_stage("stage until which the user played")
## stage_index between (inclusive) 0 and 15
func set_comleted_stage(stage_index : int):
	var rest = stage_index
	for row in [0, 1, 2, 3]:
		if rest < 4:
			tween_statue(stage_index, false)
			for i in range(row * 4, row * 4 + rest):
				stage_markers[i].add_child(PROGRESS_X.instantiate())
				await get_tree().create_timer(0.1).timeout
			break
		else:
			tween_statue(row * 4 + 3, true)
			for i in range(row * 4, (row + 1) * 4):
				stage_markers[i].add_child(PROGRESS_X.instantiate())
				await get_tree().create_timer(0.1).timeout
			await tween_statue((row + 1) * 4, true)
			
		rest -= 4

func tween_statue(idx : int, ease_out_in : bool, time : float = 0.5):
	var stage = stage_markers[idx]
	var tween = create_tween()
	if ease_out_in:
		tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(statue, "position", stage.position, time)
	await tween.finished
