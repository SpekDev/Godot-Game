extends StaticBody2D

# door
@onready var open_range: Area2D = $"open range"
@onready var open: Sprite2D = $open
@onready var closed: Sprite2D = $closed


var doorOpen :bool = false

signal door_opened
# player
@onready var player: Player = $"../../player/Player"
var hasKey : bool	
var key : RigidBody2D
var timeframe : String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# door visibility and collision
	open.visible = false
	closed.visible = false
	collision_layer = 2
	collision_mask = 2
	
	#signals connectivity
	open_range.body_entered.connect(_on_open_range_body_entered)
	player.timeframe_change.connect(_on_player_timeframe_change)
	player.key_pick.connect(_on_player_key_pick)

func _on_player_timeframe_change(timeframe_value) -> void:
	timeframe = timeframe_value
	print("dorr", timeframe)
func _process(delta: float) -> void:
	if timeframe == "present" && doorOpen:
		open.visible = true
		closed.visible = false
		
		
	elif timeframe == "present" && doorOpen == false:
		closed.visible = true
		open.visible = false
		
		
	elif timeframe == "future" && doorOpen:
		closed.visible = false
		open.visible = true
		
	else:
		closed.visible == true
		open.visible = false
		
	


	#print(timeframe_value)
	#timeframe = timeframe_value


func _on_player_key_pick(isKeyPicked: Variant) -> void:
	hasKey = isKeyPicked
	print("key = ", hasKey)


#func _on_key_picked(state) -> void:
	#hasKey = state
	#print("key = ", hasKey)


func _on_open_range_body_entered(body: Node2D) -> void:
	if body is Player and hasKey == true:
		doorOpen = true
		print("door opened")
		door_opened.emit()
		collision_layer = 0
		collision_mask = 0
			
