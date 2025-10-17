extends StaticBody2D

var currentLevelPath
var nextLevelPath
var levelNum :int
var currentLevelName
var nextLevelFile
var nextLevelName

var canPass : bool = false

@onready var button = UI.get_node("Control/Button")
@onready var hourglass= UI.get_node("Control/Control2/Sprite2D")

func _ready() -> void:
	currentLevelPath = get_tree().current_scene.scene_file_path
	var currentLevelFile = currentLevelPath.get_file()
	currentLevelName = currentLevelFile.get_basename()
	
	levelNum = int(currentLevelName[6])
	
	nextLevelPath = "res://scenes/levels/level_%d.tscn" % (levelNum + 1)
	nextLevelFile = nextLevelPath.get_file()
	nextLevelName = nextLevelFile.get_basename()

	$"../door".door_opened.connect(_if_door_open)
	$"../../player/Player".timeframe_change.connect(_on_timeframe_change)

	button.pressed.connect(_on_button_pressed)
	hourglass.modulate.a = 0
	visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and canPass == true:
		print("next scene", nextLevelPath)
		get_tree().change_scene_to_file(nextLevelPath)
		nextLevelName[5] = " "
		print(nextLevelName)

func _on_button_pressed():
	get_tree().change_scene_to_file(currentLevelPath)


func _if_door_open():
	canPass = true
	visible = true

func _on_timeframe_change(timeframe) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(hourglass, "modulate:a", 1, 0.7)

	tween.tween_interval(0.3)

	if timeframe == "present":
		tween.tween_property(hourglass, "rotation_degrees", current_rotation + 180 , 0.7)
		current_rotation = 180
	else:
		tween.tween_property(hourglass, "rotation_degrees",  current_rotation - 180 , 0.7)
		current_rotation = 0

	tween.tween_interval(0.3)
	tween.tween_property(hourglass, "modulate:a", 0, 0.7)
	
var start_rotation: int = 0
var current_rotation: int = 0

var padding = Vector2(10,-10)
