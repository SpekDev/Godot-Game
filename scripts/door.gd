extends StaticBody2D
# door
@onready var opening_range: CollisionShape2D = $"Area2D/opening range"
@onready var open: Sprite2D = $open
@onready var closed: Sprite2D = $closed


var doorOpen :bool = false

signal door_opened

@onready var player: CharacterBody2D = $"/root/player/Player"
var hasKey : bool
#keybody
var key : RigidBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# door visibility and collision
	open.visible = false
	closed.visible = true
	collision_layer = 2
	collision_mask = 2
	if player:
		player.connect("timeframe_change", Callable(self, "_on_time_changed"))
		player.connect("key_pick", Callable(self, "_on_key_picked"))
	else:
		push_error("Player does not exists")

func _on_player_timeframe_change(timeframe) -> void:
	if timeframe == "present":
		open.visible = false
		closed.visible = true
		
	elif timeframe == "future" && doorOpen == false:
		closed.visible = true
		open.visible = false
		
	else:
		closed.visible = false
		open.visible = true
		

# func _on_player_timeframe_change(timeframe_value: Variant) -> void:
# 	print(timeframe_value)
# 	timeframe = timeframe_value


# func _on_player_key_pick(isKeyPicked: Variant) -> void:
# 	hasKey = isKeyPicked
# 	print("key = ", hasKey)
#

func _on_key_picked(state) -> void:
	hasKey = state
	print("key = ", hasKey)


func _on_open_range_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.haskey == true:
		doorOpen = true
		print("door opened")
		door_opened.emit()
		collision_layer = 0
		collision_mask = 0
			
