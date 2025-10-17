extends RigidBody2D

@export var change_scale : int = 2
@onready var player = $"../../player/Player"

func _ready() -> void:
	scale_children(change_scale)
	player.connect("timeframe_change", Callable(self, "_on_time_changed"))

func scale_children(scale_factor : int) -> void:
	for child in get_children():
		if child is Node2D:
			child.scale *= scale_factor

func _on_time_changed(timeframe) -> void:
	
	if timeframe == "present":
		collision_mask = 1 << 0
		collision_layer = 1 << 0
	if timeframe == "future":
		collision_mask = 1 << 1
		collision_layer = 1 << 1
