extends CharacterBody2D

@export var movementSpeed: int = 200
@export var jumpForce: int = 300
@export var gravity := 800
@export var dashForce := 500
var isDashing :bool = false

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO
	
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x += -1
	
	if not isDashing:
		velocity.x = direction.x * movementSpeed 
	
	if Input.is_action_pressed("up") and is_on_floor():
		velocity.y = -jumpForce
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("dash") and direction.x != 0:
		dash(direction)

		
	move_and_slide()

func dash(direction: Vector2) -> void:
	isDashing = true
	velocity = direction.normalized() * dashForce
	await get_tree().create_timer(0.5).timeout
	isDashing = false


	

	
