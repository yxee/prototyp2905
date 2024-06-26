extends CharacterBody3D

# Player nodes
@onready var player = $"."
@onready var neck = $neck
@onready var head = $neck/head
@onready var eyes = $neck/head/eyes
@onready var standing_collision_shape_3d = $Standing_CollisionShape3D
@onready var crouching_collision_shape_3d = $Crouching_CollisionShape3D
@onready var ray_cast_3d = $RayCast3D_Up #for crouching
@onready var ray_cast_3d_down = $RayCast3D_Down #for floor detecting
@onready var ray_cast_3d_front = $RayCast3D_Front # for detecting climbing walls 
@onready var camera_3d = $neck/head/eyes/Camera3D
@onready var animation_player = $neck/head/eyes/AnimationPlayer

@export var grab = false
@export var atrope = false
@onready var entry = $"../climbhouse/Rope/Area3D2"
@export var climbing = false
@export var climb_speed = 5.0



# Speed vars
var currentSpeed = 5.0
@export var walkingSpeed = 5.0
@export var sprintingSpeed = 8.0
@export var crouchingSpeed = 3.0

# States
var walking = false
var sprinting = false
var crouching = false
var freeLooking = false
var sliding = false

# Slide vars
var slideTimer = 0.0
var slideTimerMax = 1.0
var slideVector = Vector2.ZERO
var slideSpeed = 10

# Head bobbing vars
const headBobbingSprintingSpeed = 22.0
const headBobbingWalkingSpeed = 14.0
const headBobbingCrouchingSpeed = 10.0

const headBobbingSprintingIntensity = 0.1
const headBobbingWalkingIntensity = 0.05
const headBobbingCrouchingIntensity = 0.05

var headBobbingVector = Vector2.ZERO
var headBobbingIndex = 0.0 
var headBobbingCurrentIntensity = 0.0

# Movement vars
@export var jumpVelocity = 4.5
var crouchingDepth = -0.5
var lerpSpeed = 10.0
var airLerpSpeed = 3.0
var freeLookTilt = 8
var lastVelocity = Vector3.ZERO
var sprintTimer = 0.0

# Player defaults
var defaultPos = Vector3.ZERO

# Input vars
@export var mouseSens = 0.2
var direction = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # hide mouse cursor
	defaultPos = player.position
	
func _input(event):
	if event is InputEventMouseMotion:
		if GlobalScript.freemovement:
			if freeLooking:
				neck.rotate_y(deg_to_rad(-event.relative.x * mouseSens))
				neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-60), deg_to_rad(60))
			else: 
				rotate_y(deg_to_rad(-event.relative.x * mouseSens))
				head.rotate_x(deg_to_rad(-event.relative.y * mouseSens))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))






func _physics_process(delta):
	

	# Resetting Player Position
	#print(player.position.y)
	if player.position.y <= -12.0:
		player.position = defaultPos
	
	# Getting movement input 
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	
	# handle movement state
	
	# Crouching
	if Input.is_action_pressed("crouch") || sliding:
		currentSpeed = lerp(currentSpeed, crouchingSpeed, delta * lerpSpeed)
		head.position.y = lerp(head.position.y, crouchingDepth, delta * lerpSpeed)
		standing_collision_shape_3d.disabled = true
		crouching_collision_shape_3d.disabled = false
		
		# slide begin logic
		if sprinting && input_dir != Vector2.ZERO:
			sliding = true
			slideTimer = slideTimerMax
			slideVector = input_dir
			freeLooking = true
			print("Slide start")
		
		walking = false
		sprinting = false
		crouching = true
		
	elif !ray_cast_3d.is_colliding(): 
		
		# Standing
		head.position.y = lerp(head.position.y, 0.0, delta * lerpSpeed)
		standing_collision_shape_3d.disabled = false
		crouching_collision_shape_3d.disabled = true
		
		# Manage Sprinting / Walking
		if Input.is_action_just_released("forward"):
			sprintTimer = 0.2
		
		if sprintTimer > 0:
			if Input.is_action_pressed("forward"):
				if is_on_floor():
					currentSpeed = lerp(currentSpeed, sprintingSpeed, delta * lerpSpeed)
					walking = false
					sprinting = true
					crouching = false
					#climbing = false
			else:
				sprintTimer -= delta
		else: 
			if Input.is_action_pressed("forward"):
				if is_on_floor():
					currentSpeed = lerp(currentSpeed, walkingSpeed, delta * lerpSpeed)
					walking = true
					sprinting = false
					crouching = false
					#climbing = false
			
		#if Input.is_action_pressed("sprint"):
			## Sprinting
			#if is_on_floor():
				#currentSpeed = lerp(currentSpeed, sprintingSpeed, delta * lerpSpeed)
				#walking = false
				#sprinting = true
				#crouching = false
				#climbing = false
				#
		#else:
			## Walking
			#if is_on_floor():
				#currentSpeed = lerp(currentSpeed, walkingSpeed, delta * lerpSpeed)
				#walking = true
				#sprinting = false
				#crouching = false
				#climbing = false
			
	# Handle free looking
	if Input.is_action_pressed("free_look") || sliding:
		freeLooking = true
		if sliding: 
			eyes.rotation.z = lerp(eyes.rotation.z, -deg_to_rad(7.0), delta*lerpSpeed)
		else:
			eyes.rotation.z = -deg_to_rad(neck.rotation.y*freeLookTilt)
	else: 
		freeLooking = false
		neck.rotation.y = lerp(neck.rotation.y, 0.0, delta*lerpSpeed)
		eyes.rotation.z = lerp(eyes.rotation.z, 0.0, delta*lerpSpeed)
	
	# Handle sliding
	if sliding: 
		slideTimer -= delta
		if slideTimer <= 0:
			sliding = false
			freeLooking = false
			print("Slide end")
			
	# Handle Headbob
	if sprinting: 
		headBobbingCurrentIntensity = headBobbingSprintingIntensity
		headBobbingIndex += headBobbingSprintingSpeed*delta
	elif walking:
		headBobbingCurrentIntensity = headBobbingWalkingIntensity
		headBobbingIndex += headBobbingWalkingSpeed*delta
	elif crouching:
		headBobbingCurrentIntensity = headBobbingCrouchingIntensity
		headBobbingIndex += headBobbingCrouchingSpeed*delta
		
	if is_on_floor() && !sliding && input_dir != Vector2.ZERO:
		headBobbingVector.y = sin(headBobbingIndex)
		headBobbingVector.x = sin(headBobbingIndex/2)+0.5
		eyes.position.y = lerp(eyes.position.y, headBobbingVector.y*(headBobbingCurrentIntensity/2.0), delta*lerpSpeed)
		eyes.position.x = lerp(eyes.position.x, headBobbingVector.x*headBobbingCurrentIntensity, delta*lerpSpeed)

	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta*lerpSpeed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta*lerpSpeed)
		
	# Add the gravity.
	if not is_on_floor() && !climbing:
		velocity.y -= gravity * delta
	elif climbing: # climbing
		velocity.y = 0.0
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpVelocity
		sliding = false
		animation_player.play("jump")
		print("jump")
		

		
	# Handle landing
	if is_on_floor():
		if lastVelocity.y < -10.0:
			animation_player.play("roll")
			print("roll")

		elif lastVelocity.y < -4.0:
			animation_player.play("landing")
			print("landing")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions
	if is_on_floor():
		direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerpSpeed)
		
	else:
		if input_dir != Vector2.ZERO:
			direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * airLerpSpeed)
				
	if sliding:
		direction = (transform.basis * Vector3(slideVector.x,0, slideVector.y)).normalized()
		currentSpeed = (slideTimer +0.1) * slideSpeed
		
	if direction:
		velocity.x = direction.x * currentSpeed
		velocity.z = direction.z * currentSpeed
					
	else:
		velocity.x = move_toward(velocity.x, 0, currentSpeed)
		velocity.z = move_toward(velocity.z, 0, currentSpeed)

	lastVelocity = velocity
	move_and_slide()



func _on_rope_body_entered(body):
	if body.is_in_group("Climber"):
		print("whee")
	pass # Replace with function body.


func _on_area_3d_area_entered(body):
	if body.is_in_group("Climber"):
		print("whee")
	pass # Replace with function body.
