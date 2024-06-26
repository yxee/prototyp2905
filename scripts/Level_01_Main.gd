extends Node3D

@onready var pause_menu =$CharacterBody3D/Head/Eyes/Cam1st/PauseMainMenu
@onready var anim = $AnimationPlayer
var animhandler = true
var paused = false
var random = RandomNumberGenerator.new()
var textfinish = false
@export var spawn_number = 50
#@export var spawn_object = preload("res://scenes/pine_tree.tscn")

func _ready():
	$Intro/IntroCam.set_current(true)
	#anim.play("text_read")

#func getRandomPosition(size) -> Vector3:
	#random.randomize()
	#var x = random.randf_range(-abs(size/2), abs(size/2))
	#var z = random.randf_range(-abs(size/2), abs(size/2))
	#var y = random.randf_range(-1,-1)
	#return Vector3(x,y,z)
#func getRandomRotation(rotation) -> Vector3:
	#random.randomize()
	#var x = 0
	#var z = 0
	#var y = random.randf_range(-180,180)
	#return Vector3(x,y,z)
#func spawn():
	#for i in spawn_number:
		#var obj = spawn_object.instantiate()
		#obj.position = getRandomPosition(70)
		#obj.rotation = getRandomRotation(180)
		#add_child(obj)

func _process(delta):
	
	if animhandler && Input.is_action_just_pressed("Activate"):
		$Intro/Control.hide()
		$"Intro/IntroCam/press e___".hide()
		anim.play("Move_cam1")
		
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
		
	
		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		pause_menu.show()
		Engine.time_scale = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	GlobalScript.freemovement = !GlobalScript.freemovement
	paused = !paused


	
func _on_animation_player_animation_finished(anim_name):
	
	#if anim_name == "text_read":
		#animhandler = true
	if anim_name == "Move_cam1":
		$CharacterBody3D/Head/Cam3rd.set_current(true)
		GlobalScript.freemovement = true
		GlobalScript.camcontroll = true
	pass # Replace with function body.
	
