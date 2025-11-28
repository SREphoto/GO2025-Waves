class_name Explosion
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal exploded

func _ready() -> void:
	self.visible = false

func explode():
	SoundManager.explosion_player.play()
	await get_tree().create_timer(0.1).timeout
	self.visible = true
	animation_player.play("EXPLODE")
	await animation_player.animation_finished
	exploded.emit()
	self.visible = false
