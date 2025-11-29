class_name HealthBarUI
extends CanvasLayer

@export var game_variables : GameVariables

@export var max_health : int = 100
@export var health : int = 100
@export var health_after_attack : int = 100

@onready var health_bar: TextureProgressBar = $Control/HealthBar
@onready var health_after_attack_bar: TextureProgressBar = $Control/HealthAfterAttackBar
@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@onready var waves: Label = $Control/HealthBar/Waves
@onready var time: Label = $Control/HealthBar/Time

func _ready() -> void:
	pass

func connect_signal() -> void:
	game_variables.connect("values_changed", refresh)

func initialize():
	max_health = game_variables.current_goal
	health = max_health
	health_after_attack = max_health
	
	health_bar.max_value = max_health
	health_bar.value = max_health
	health_after_attack_bar.max_value = max_health
	health_after_attack_bar.value = max_health

func refresh():
	health =  game_variables.current_goal
	health_after_attack = health - game_variables.current_score
	_set_health_bar()
	
	waves.text = "Waves: " + str(game_variables.remaining_waves)
	var remaining_time: int = max(0, game_variables.remaining_time)
	time.text = "Time: " + str(remaining_time)

func _set_health_bar():
	health_bar.value = health
	health_after_attack_bar.value = health_after_attack

func blend_in() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 1), 0.8)

func blend_out() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(canvas_modulate, "color", Color(1, 1, 1, 0), 0.8)

func hard_mode():
	$Poseidon/PoseidonAngry.play("hard_mode")
	$Major/MajorAngry.play("hard_mode")
	$Control/HealthAfterAttackBar/BossName.text = "THE MAYOR"


func _on_skip_button_mouse_entered() -> void:
	pass # Replace with function body.
