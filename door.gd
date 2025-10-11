extends StaticBody2D
# door
@onready var opening_range: CollisionShape2D = $"Area2D/opening range"
@onready var open: Sprite2D = $open
@onready var closed: Sprite2D = $closed

var doorOpen :bool = false


# player
@onready var player: CharacterBody2D = $"../Player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# door visibility and collision
	open.visible = false
	closed.visible = false
	collision_layer = 2
	collision_mask = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	




func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == CharacterBody2D:
		if body.hasKey == true:
			print("haskey")
