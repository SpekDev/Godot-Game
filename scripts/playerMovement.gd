extends CharacterBody2D
#player properties
@export var movementSpeed: int = 500
@export var jumpForce: int = 500
@export var gravity := 500
@export var dashForce := 1000
#dashing varibables
var isDashing :bool = false
var canDash :bool = true
#node refferences
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var dash_timer: Timer = $"dash timer"
@onready var dash_cooldown: Timer = $"dash  cooldown"
#player flipping
var facingLeft := false





func _physics_process(delta: float) -> void:
	#animations
	if velocity.x > 1 && is_on_floor() || velocity.x < -1 && is_on_floor():
		animated_sprite_2d.animation = "run"
	
	elif velocity.x == 0 && velocity.y == 0:
		animated_sprite_2d.animation = "idle"	

	
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
	
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -jumpForce
		animated_sprite_2d.animation = "jump" #jump animations
		print(jumpForce)
	
	# Apply gravity
	if not is_on_floor() && isDashing == false:
		velocity.y += gravity * delta
		
	#dash input
	if Input.is_action_just_pressed("dash") and direction.x != 0 && isDashing != true && canDash:
		dash(direction)

		
	move_and_slide()
	
	#flipping character
	if velocity.x < 0:
		facingLeft = true
	elif velocity.x > 0:
		facingLeft = false

	animated_sprite_2d.flip_h = facingLeft

#dashing
func dash(direction: Vector2) -> void:
	isDashing = true
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
