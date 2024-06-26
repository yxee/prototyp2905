extends CharacterBody3D

@export var speed = 5.0
@export var SPRINT_SPEED = 5.0
@export var WALK_SPEED = 2.5
@export var JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 0.003
var lerpSpeed = 10.0

var walking = true
@export var climbing = false
@export var grab = false
@export var move_duration = 2
@export var cam_perspective = false

@export var is_climbing = false
@export var climb_speed = 15.0
@export var climb_challenge_interval = 2.0
@export var balance_threshold = 0.1
var climb_progress = 0.0
var balance = 0.5
var timerout = null
@onready var challenge_timer = $Timer
var buttona = false
var climbup_a = false
var climb_debuf = false
var climbing_restart = false

var move_timer = 0
var initial_position = Vector3()
@export var atdoor = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
@export var gravity = 9.8

@onready var head = $Head
@onready var camera = $Head/Eyes/Cam1st

@onready var eyes = $Head/Eyes
@onready var buttonA = $"Head/Button A"
@onready var buttonD = $"Head/Button D"
@onready var buttonSpace = $Head/Space

@onready var firstcam = $Head/Eyes/Cam1st
@onready var thirdcam = $Head/Cam3rd
@export var transition_duration: float = 2.0
@onready var active_camera = $Head/Eyes/Cam1st
@onready var target_camera = $Head/Cam3rd
var transitioning = false
var transition_time: float = 0.0
var originalpos



const headBobbingSprintingSpeed = 22.0
const headBobbingWalkingSpeed = 14.0

const headBobbingSprintingIntensity = 0.1
const headBobbingWalkingIntensity = 0.08

var headBobbingVector = Vector2.ZERO
var headBobbingIndex = 0.0 
var headBobbingCurrentIntensity = 0.0

var thirdposrotate = Vector3()
var firstposrotate = Vector3()

var tutorialkill = false
var taschenlampe = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Set the initial active camera
	active_camera = thirdcam
	target_camera = firstcam
	active_camera.current = true
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		if GlobalScript.freemovement:
			head.rotation.z -= -event.relative.y * SENSITIVITY
			head.rotation.z = clamp(head.rotation.z, deg_to_rad(-30), deg_to_rad(25))
			
			if cam_perspective:
				head.rotation.y -= event.relative.x * SENSITIVITY
				#rotation.y -= event.relative.x * SENSITIVITY
			if !cam_perspective:
				head.rotation.y -= event.relative.x * SENSITIVITY
		if Input.is_action_pressed("uiup"):
			$AnimatedSprite3D.set_billboard_mode(2)
		

func _physics_process(delta):
	
	
	
	
	#print(Engine.get_frames_per_second()) 
	var entry = GlobalScript.entry
	
	if GlobalScript.climbenergy >= 150.0:
		if GlobalScript.climbenergy >= 200.0:
			climb_speed = 0.01
		else:
			climb_speed = 0.5
	if GlobalScript.climbenergy < 0.0:
		GlobalScript.climbenergy = 0.0
	
	initial_position = $".".global_transform.origin
	if Input.is_action_just_pressed("grabbing"):
		grab = !grab
		$AnimatedSprite3D.rotation.y = head.rotation.y -80

	if Input.is_action_just_pressed("grabbing") && !grab:
		print("notgrab")
		
	if Input.is_action_just_pressed("grabbing") && grab && climbing:
		start_climbing()
		
		
	if atdoor && Input.is_action_just_pressed("grabbing"):
		position = entry
		
	elif climbing == true:
		velocity.y = 0
		if grab:
			
			
			if Input.is_action_just_released("uileft") && !timerout &&  buttona:
				#velocity.y = climb_speed
				GlobalScript.climbenergy += 1.0
				buttona = false
				climbup_a = true
				start_climbing()
				if climbing_restart:
					challenge_timer.paused = false
					climbing_restart = false
				
				#print(GlobalScript.climbenergy)
			elif Input.is_action_just_released("uiright") && !timerout && !buttona:
				#velocity.y = climb_speed
				GlobalScript.climbenergy + 0.1
				buttona = true
				climbup_a = false
				start_climbing()
			if buttona:
				buttonA.show()
				buttonD.hide()
			if !buttona:
				buttonA.hide()
				buttonD.show()
			
			
			
			if challenge_timer.time_left <= 0.5:
				climb_debuf = true
				buttonSpace.show()
			
			if climb_debuf && Input.is_action_just_pressed("space"):
				climb_restart()
				climb_debuf = false
				buttonSpace.hide()
				
			if challenge_timer.time_left <= 0:
				climb_restart()
				climb_debuf = false
				buttonSpace.hide()
				
			if climbup_a:
				velocity.y = 0.5
			elif climb_debuf:
				velocity.y = -3
			else:
				velocity.y = 0
				
			#if climb_debuf:
				#velocity.y = -1
			#else:
				#velocity.y = 0

	elif !grab:
			climbing == false
			velocity.y == gravity
			buttonA.hide()
			buttonD.hide()


	if Input.is_action_just_pressed("perspective"):
		#cam_perspective = !cam_perspective
		switch_camera()
		
		$AnimatedSprite3D.rotation.y = head.rotation.y -80
		#$AnimatedSprite3D.set_billboard_mode(2)

	if Input.is_action_pressed("uiup") && !cam_perspective:
		$AnimatedSprite3D.rotation.y = head.rotation.y -80
			
	if Input.is_action_pressed("uidown") && !cam_perspective:
		$AnimatedSprite3D.rotation.y = head.rotation.y +80
		
	
	else:
		$AnimatedSprite3D.set_billboard_mode(0)
		
	#if cam_perspective && GlobalScript.camcontroll && !grab:
			#camera.position = Vector3(-0.242,0.675,0)
			#camera.rotation.x = 0
			#$Head/Eyes/PlayerCam.set_current(true)
			#$AnimatedSprite3D.set_billboard_mode(2)
			
	#if !cam_perspective && GlobalScript.camcontroll && !grab:
			#$Head/Camera3D.set_current(true)
			#set mesh rotate here
			#$AnimatedSprite3D.rotation.y = head.rotation.y + 90
			#$AnimatedSprite3D.set_billboard_mode(0)
			
	if climbing && grab:
		$"../climbhouse/ClimbCam".set_current(true)
		
		
		

	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	var input_dir = Input.get_vector("uileft", "uiright", "uiup", "uidown")
	var head_forward = head.transform.basis.z.normalized()
	var head_right = head.transform.basis.x.normalized()
	var direction = ($Head.transform.basis * Vector3(input_dir.y, 0, -input_dir.x)).normalized()
	
	#if !cam_perspective:
		#direction = ($ThirdPos.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		#if Input.is_action_pressed("uiup"):
			#thirdposrotate = $ThirdPos.rotation.y
			#$AnimatedSprite3D.rotation.y = thirdposrotate
		#if Input.is_action_pressed("uidown"):
			#thirdposrotate = $ThirdPos.rotation.y
			#$AnimatedSprite3D.rotation.y = -thirdposrotate +90
	
	#if cam_perspective:
		#direction = (transform.basis * Vector3(input_dir.y, 0, -input_dir.x)).normalized()
		#if Input.is_action_pressed("uiup"):
			#firstposrotate = $Head.rotation.y
			#$AnimatedSprite3D.rotation.y = firstposrotate
	
	if walking:
		headBobbingCurrentIntensity = headBobbingWalkingIntensity
		headBobbingIndex += headBobbingWalkingSpeed*delta
	
	if is_on_floor() && input_dir != Vector2.ZERO:
		headBobbingVector.y = sin(headBobbingIndex)
		headBobbingVector.x = sin(headBobbingIndex/2)+0.5
		eyes.position.y = lerp(eyes.position.y, headBobbingVector.y*(headBobbingCurrentIntensity/2.0), delta*lerpSpeed)
		eyes.position.x = lerp(eyes.position.x, headBobbingVector.x*headBobbingCurrentIntensity, delta*lerpSpeed)
	
	
	if Input.is_action_just_pressed("taschenlampe"):
		taschenlampe = !taschenlampe
		
	if taschenlampe:
		$Head/Eyes/Taschenlampe.show()
	else:
		$Head/Eyes/Taschenlampe.hide()
	
	
	
	
	if !grab:
		velocity = direction * speed
		if is_on_floor():
			velocity.y = 0
		
		elif !is_on_floor():
			velocity.y = -gravity
		
	if transitioning:
		transition_time += delta
		var t = min(transition_time / transition_duration, 1.0)
		

		# Interpolate position and rotation
		var new_transform = active_camera.transform.interpolate_with(target_camera.transform, t)
		active_camera.transform = new_transform
		print("istransitioning")
		print(originalpos)
		if t >= 1.0:
			_on_transition_completed()
	
	
	
	move_and_slide()
	#print(challenge_timer.time_left)
	
		
		

func switch_camera():

	# Ensure the target camera is set to current after the transition
	originalpos = active_camera.position
	transitioning = true
	transition_time = 0.0

func _on_transition_completed():
	print("transitionfinished")
	transitioning = false
	active_camera.current = false
	target_camera.current = true
	#active_camera.position = originalpos
	
	# Swap the active and target cameras
	var temp = active_camera
	active_camera = target_camera
	target_camera = temp
	print(target_camera)


func start_climbing():
	challenge_timer.wait_time = climb_challenge_interval
	challenge_timer.start(-2)
	
	
	#if Input.is_action_just_pressed("uileft"):
		#if (challenge_timer.time_left > 0):
		#	velocity.y = climb_speed
			#GlobalScript.climbenergy += 1.0
			#buttona = true
		#else: 
			#velocity.y = 0
			#print("outoftime")
	
	#if Input.is_action_just_pressed("uiright"):
		#if (challenge_timer.time_left > 0):
		#	velocity.y = climb_speed
		#	GlobalScript.climbenergy += 1.0
		#	buttona = false
		#else: 
		#	velocity.y = 0
	pass



func climb_restart():
	challenge_timer.start(-2)
	challenge_timer.paused = true
	climbup_a = false
	climbing_restart = true


func _on_area_3d_body_entered(body):
	if body.is_in_group("Climber"):
		if body.climbing == false:
			climbing = true
		print(climbing)
		
	


func _on_area_3d_body_exited(body):
	if body.is_in_group("Climber"):
		if body.climbing == true:
			climbing = false
			grab = false
		print(climbing)
	if body.is_in_group("Radio1"):
		print("radio2 collected")

func _on_area_3d_2_body_entered(body):
	if body.is_in_group("Climber"):
		print ("yuhu")
		print(initial_position)
		atdoor = true
			
func _on_area_3d_2_body_exited(body):
	if body.is_in_group("Climber"):
		atdoor = false



	#if body.is_in_group("Climber"):
		#cam_perspective = false


	#if body.is_in_group("Climber"):
		#cam_perspective = true
	
	
func _on_second_picture_body_entered(body):
	if body.is_in_group("Climber"):
		cam_perspective = true
	pass # Replace with function body.

func _on_second_picture_body_exited(body):
	if body.is_in_group("Climber"):
		cam_perspective = false
	pass # Replace with function body.


func _on_food_body_entered(body):
	if body.is_in_group("Climber"):
		GlobalScript.climbenergy -= 50
		#$"../Food".queue_free()
	pass # Replace with function body.



func _on_picture_area_body_entered(body):
	if body.is_in_group("Climber"):
		active_camera = $Head/Eyes/Cam1st
		switch_camera()



func _on_picture_area_body_exited(body):
	if body.is_in_group("Climber"):
		active_camera = $Head/Cam3rd
		switch_camera()
		
	pass # Replace with function body.


func _on_kill_tutorial_body_entered(body):
	
	if body.is_in_group("Climber") && !tutorialkill:
		$Head/Eyes/Cam1st/AnimatedSprite3D.queue_free()
		tutorialkill = true
	pass # Replace with function body.


func _on_ridoquest_body_body_entered(body):
	
	pass # Replace with function body.


#func _on_timer_timeout():
	#timerout = true
	pass # Replace with function body.
