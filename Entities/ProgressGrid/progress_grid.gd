class_name ProgressGrid
extends Node2D

@onready var statue: StaticBody2D = $Statue
@onready var stages: Node2D = $Stages

const PROGRESS_X = preload("uid://4nu336d5a2bg")
var progress: int = 0

var last_stage_index: int

var stage_markers : Array[Node2D] = []

signal movement_done()

func _ready() -> void:
	for child in stages.get_children():
		if child is Node2D:
			stage_markers.append(child)
	
	last_stage_index = set_stage_last(GlobalVariables.bosses_completed_last)
	set_progress_x(GlobalVariables.bosses_completed_max)
	await get_tree().create_timer(1).timeout
	move_to_stage(GlobalVariables.bosses_completed_now)
	#set_comleted_stage(GlobalVariables.bosses_completed_now)

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

func set_stage_last(stage_index: int) -> int:
	statue.position = stage_markers[stage_index].position
	return stage_index

func move_to_stage(stage_index: int) -> void:
	var direction: int = sign(stage_index - last_stage_index)
	var times: int = 0
	var time: float = 0.4
	for i in range(last_stage_index, stage_index, direction):
		var next_stage_marker: Node2D = stage_markers[i+direction]
		var stage_marker: Node2D = stage_markers[i]
		if next_stage_marker.position.y == stage_marker.position.y:
			times +=1
			continue
		spawn_progress_x(i, direction, times, time/4)
		times = 0
		await tween_statue(i, true, time)
		await tween_statue(i+direction, true, time/2)
	spawn_progress_x(stage_index, direction, times, time/4)
	await tween_statue(stage_index, true, time)
	
	movement_done.emit()

func set_progress_x(progress_max: int) -> void:
	for i in range(progress_max + 1):
		stage_markers[i].add_child(PROGRESS_X.instantiate())

func spawn_progress_x(index: int, dir: int, times: int, time: float) -> void:
	for i in range(times, -1, -dir):
		var j: int = index - i
		stage_markers[j].add_child(PROGRESS_X.instantiate())
		await get_tree().create_timer(time).timeout

func tween_statue(idx : int, ease_out_in : bool, time : float = 0.4):
	var stage = stage_markers[idx]
	var tween = create_tween()
	if ease_out_in:
		tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC).tween_property(statue, "position", stage.position, time)
	await tween.finished
