extends Node2D

@export var change_scale : int = 3


func _ready() -> void:
	scale_children(change_scale)

func scale_children(scale_factor : int) -> void:
	for child in get_children():
		if child is Node2D:
			child.scale *= scale_factor
