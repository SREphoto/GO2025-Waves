class_name Clock
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_ticks():
	animation_player.play("Tick")
