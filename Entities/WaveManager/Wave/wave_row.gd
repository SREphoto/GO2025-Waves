class_name WaveRow
extends Node2D

@onready var double_tile: AnimatedSprite2D = $DoubleTile
@onready var first_tile: AnimatedSprite2D = $FirstTile
@onready var second_tile: AnimatedSprite2D = $SecondTile
@onready var third_tile: AnimatedSprite2D = $ThirdTile
@onready var timer: Timer = $Timer

@export var double : bool = true
@export var foam_time = 1.0

signal wave_retreating
signal wave_row_finished()

func _ready() -> void:
	if not double:
		position.x -= 32
	double_tile.visible = false
	first_tile.visible = false
	second_tile.visible = false
	third_tile.visible = false

func start_wave():
	await _wave_in()
	third_tile.visible = true
	third_tile.play("Foam")
	timer.start(foam_time)
	wave_retreating.emit()
	await timer.timeout
	await _wave_out()
	wave_row_finished.emit()

func _wave_in():
	if double:
		double_tile.visible = true
		double_tile.play("WaveIn")
		await double_tile.animation_finished
		double_tile.play("Water")
	first_tile.visible = true
	first_tile.play("WaveIn")
	await first_tile.animation_finished
	first_tile.play("Water")
	second_tile.visible = true
	second_tile.play("WaveInLast")
	await second_tile.animation_finished
	second_tile.play("WaterLast")

func _wave_out():
	third_tile.visible = false
	second_tile.play("WaveOutLast")
	await second_tile.animation_finished
	second_tile.visible = false
	first_tile.play("WaveOut")
	await first_tile.animation_finished
	first_tile.visible = false
	if double:
		double_tile.play("WaveOut")
		await double_tile.animation_finished
		double_tile.visible = false
