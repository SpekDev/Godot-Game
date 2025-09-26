extends Area2D

@export var target_cam: Camera2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body :Node) -> void:
	target_cam.make_current()
	await get_tree().create_timer(1).timeout
	
	
