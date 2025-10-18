extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")
	UI.visible = true
	print("game started")


func _on_tutorial_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/tutorial.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit(0)
