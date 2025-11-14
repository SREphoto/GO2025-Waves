class_name ScoringResource
extends Resource

enum COLORS {
	RED,
	GREEN,
	BLUE
}

@export var color: COLORS
@export var group: Array[Vector2i]
@export var size: Array[Vector2i]
@export var danger: bool
