extends CharacterBody2D
#player properties
@export var movementSpeed: int = 500
@export var jumpForce: int = 500
@export var gravity := 1000
@export var dashForce := 1000
const PUSH_FORCE := 15
const MIN_PUSH_FORCE := 15
#dashing varibables
var isDashing :bool = false
var canDash :bool = true
#node refferences
@onready var label: Label = $"../Label"
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $"dash timer"
@onready var dash_cooldown: Timer = $"dash  cooldown"
var timeframe := "present"

# signals

# tilemaps
@onready var future_tilemap: TileMapLayer = $"../../future/future tilemap"
@onready var present_tilemap: TileMapLayer = $"../../present/present tilemap"
@onready var present_background: Sprite2D = $"../../present/present background"
@onready var background_clouds: Sprite2D = $"../../future/BackgroundClouds"

# carrying
var isInRange: bool = false
var targetObject: Node2D
@onready var hand: Marker2D = $hand

@onready var hasKey: bool = false



#player flipping
var facingLeft := false
#spawn pos
var spawn_position: Vector2

func _ready() -> void:
	spawn_position = position
	future_tilemap.visible = false
	background_clouds.visible = false
	
	present_tilemap.visible = true
	present_background.visible = true
	
	# carrying
	hasKey = false
	print(hasKey)
func _input(event: InputEvent) -> void:

	# timeframe switching
	if Input.is_action_just_pressed("timejump"):
		if timeframe == "present":
			timeframe = "future"
			position = spawn_position
			future_tilemap.visible = true
			background_clouds.visible = true
			
			present_background.visible = false
			present_tilemap.visible = false
			label.text = "future"
			
		elif timeframe == "future":
			timeframe = "present"
			position = spawn_position
			future_tilemap.visible = false
			background_clouds.visible = false
			
			present_background.visible = true
			present_tilemap.visible = true
			label.text = "present"
			
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
	if Input.is_action_just_pressed("dash") and direction.x != 0 && isDashing != true && canDash:
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
			targetObject.reparent(hand)
			targetObject.position = hand.position
			# stopping collisons and physics
			if targetObject is RigidBody2D:
				targetObject.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
				targetObject.freeze = true
				targetObject.collision_layer = 0
				targetObject.collision_mask = 0
		
		hasKey = true


func _on_range_body_entered(body: Node2D) -> void:
	if body is Pickable:
		isInRange = true
		targetObject = body


func _on_range_body_exited(body: Node2D) -> void:
	if body is Pickable:
		isInRange = false
		targetObject = null
