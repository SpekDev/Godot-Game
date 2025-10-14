extends StaticBody2D
# door
@onready var opening_range: CollisionShape2D = $"Area2D/opening range"
@onready var open: Sprite2D = $open
@onready var closed: Sprite2D = $closed


var doorOpen :bool = false

signal door_opened
# player
@onready var player: CharacterBody2D = $"/root/player/Player"
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
	player.timeframe_change.connect(_on_player_timeframe_change)
	player.key_pick.connect(_on_player_key_pick)
	$"Area2D/opening range".body_entered.connect(_on_open_range_body_entered)

func _on_player_timeframe_change(timeframe_value) -> void:
	timeframe = timeframe_value
	print("dorr", timeframe)
func _process(delta: float) -> void:
	if timeframe == "present":
		open.visible = false
		closed.visible = false
		
		
	elif timeframe == "future" && doorOpen == false:
		closed.visible = true
		open.visible = false
		
		
	else:
		closed.visible = false
		open.visible = true
		
	


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
			
