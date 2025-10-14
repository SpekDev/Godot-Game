extends StaticBody2D
var currentLevelPath
var nextLevelPath
var levelNum :int
var currentLevelName
var nextLevelFile
var nextLevelName

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentLevelPath = get_tree().current_scene.scene_file_path
	var currentLevelFile = currentLevelPath.get_file()
	currentLevelName = currentLevelFile.get_basename()
	
	levelNum = int(currentLevelName[6])
	
	nextLevelPath = "res://scenes/levels/level_%d.tscn" % (levelNum + 1)
	nextLevelFile = nextLevelPath.get_file()
	nextLevelName = nextLevelFile.get_basename()





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		print("next scene", nextLevelPath)
		get_tree().change_scene_to_file(nextLevelPath)
		nextLevelName[5] = " "
		print(nextLevelName)
