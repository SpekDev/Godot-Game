extends CharacterBody2D

class_name Player

#player properties
@export var movementSpeed: int = 500
@export var jumpForce: int = 500
@export var gravity := 1000
@export var dashForce := 1000

const PUSH_FORCE := 15
const MIN_PUSH_FORCE := 15

#dashing varibables
var isDashing : bool = false
var canDash : bool = true

#node references
@onready var label: Label = $"../../objects/Label"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $"dash timer"
@onready var dash_cooldown: Timer = $"dash  cooldown"

var timeframe := "present"

# signals
signal timeframe_change(timeframe_value)
signal key_pick(isKeyPicked)

#objects
@onready var door: StaticBody2D = $"../../objects/door"
# tilemaps 
@onready var future_background: Sprite2D = $"../../future/FutureBackground"
@onready var future_tilemap: TileMapLayer = $"../../future/future tilemap"
@onready var present_background: Sprite2D = $"../../present/PresentBackground"
@onready var present_tilemap: TileMapLayer = $"../../present/present tilemap"


# carrying
var isInRange: bool = false
var targetObject: Node2D

@onready var hand: Marker2D = $hand
@onready var hasKey: bool = false
var held_object : RigidBody2D

#player flipping
var facingLeft := false
#spawn pos
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = position
	future_tilemap.visible = false
	future_background.visible = false

	present_tilemap.visible = true
	present_background.visible = true

	timeframe_change.emit(timeframe)
	
	# SIGNALS connectiviyty
 
# Connect area signals for pickup range
	$range.body_entered.connect(_on_range_body_entered)
	$range.body_exited.connect(_on_range_body_exited)

	# Connect door signal
	door.door_opened.connect(_on_door_door_opened)

	# Connect dash timers
	dash_timer.timeout.connect(_on_dash_timer_timeout)
	dash_cooldown.timeout.connect(_on_dash__cooldown_timeout)
	
	# carrying
	hasKey = false
	print("have_key = ", hasKey)

func _input(event: InputEvent) -> void:
	# timeframe switching
	if Input.is_action_just_pressed("timejump"):
		if timeframe == "present":
			timeframe = "future"
			position = spawn_position
			future_tilemap.visible = true
			future_background.visible = true
			timeframe_change.emit(timeframe)
			
			present_background.visible = false
			present_tilemap.visible = false
			#label.text = "future"
			
		elif timeframe == "future":
			timeframe = "present"
			position = spawn_position
			future_tilemap.visible = false
			future_background.visible = false
			
			present_background.visible = true
			present_tilemap.visible = true
			#label.text = "present"
			timeframe_change.emit(timeframe)
			
		# timeframe collisions
		if timeframe == "present":
			collision_mask = 1 << 0  # layer 1 (bit 0)
		elif timeframe == "future":
			collision_mask = 1 << 1  # layer 2 (bit 1)


func _physics_process(delta: float) -> void:
	#pickup
	pickup_object()
	
	#animations
	if velocity.x > 1 && is_on_floor() || velocity.x < -1 && is_on_floor():
		animated_sprite_2d.animation = timeframe + "_run"
		animated_sprite_2d.play(timeframe + "_run")
	
	elif velocity.x == 0 && velocity.y == 0:
		animated_sprite_2d.animation = timeframe + "_idle"

	
	#player movement
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x += -1
	# if Input.is_action_pressed("up"):
	# 	direction.y += -1
	# if Input.is_action_pressed("down"):
	# 	direction.y += 1
	
	if isDashing:
		pass
	else:
		velocity.x = direction.x * movementSpeed 
	#jump
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -jumpForce
		animated_sprite_2d.animation = timeframe + "_jump" #jump animations
		gravity = 1000							
		print(jumpForce)
	
	# Apply gravity
	if not is_on_floor() && isDashing == false:
		gravity += 1
		velocity.y += gravity * delta
		
	#dash input
	if Input.is_action_just_pressed("dash") and direction != Vector2.ZERO && isDashing != true && canDash:
		dash(direction)

	move_and_slide()
	
	#pusing objects
	for object in get_slide_collision_count():
		var collision = get_slide_collision(object)
		if collision.get_collider() is RigidBody2D:
			var pushForce = (PUSH_FORCE * velocity.length() / movementSpeed) + MIN_PUSH_FORCE
			collision.get_collider().apply_impulse(-collision.get_normal() * pushForce)
			
	#flipping character
	if velocity.x < 0:
		facingLeft = true
	elif velocity.x > 0:
		facingLeft = false

	animated_sprite_2d.flip_h = facingLeft

#dashing
func dash(direction: Vector2) -> void:
	isDashing = true
	animated_sprite_2d.animation = timeframe + "_dash"
	print(isDashing)
	print(dashForce)
	# velocity = direction.normalized() * dashForce
	velocity = direction * dashForce
	dash_timer.start()
	dash_cooldown.start()
	canDash = false

func _on_dash_timer_timeout() -> void:
	isDashing = false
	print(isDashing)


func _on_dash__cooldown_timeout() -> void:
	canDash = true
	print(canDash)

#picking up items
func pickup_object() -> void:
	if timeframe == "future":
		if isInRange == true:
			held_object = targetObject
			held_object.reparent(hand)
			held_object.position = hand.position
			hasKey = true
			key_pick.emit(hasKey)
			# stopping collisons and physics
			if held_object is RigidBody2D:
				held_object.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
				held_object.freeze = true
				held_object.collision_layer = 0
				held_object.collision_mask = 0
			
				
func drop_object() -> void:
	if hasKey == true:
		print(held_object)
		held_object.queue_free()
		
	else:
		print("Drop failed:", isInRange, hasKey, targetObject)
		
func _on_range_body_entered(body: Node2D) -> void:
	if body is Pickable:
		isInRange = true
		targetObject = body


func _on_range_body_exited(body: Node2D) -> void:
	if body is Pickable:
		isInRange = false
		targetObject = null


func _on_door_door_opened() -> void:
	drop_object()
	hasKey = false
