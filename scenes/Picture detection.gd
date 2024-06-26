extends Area3D

@onready var player = $"../../CharacterBody3D"
var visibility_radius = 4.0
var transparancylevel = 0.0
var fotocollected = false


# Called when the node enters the scene tree for the firste time.
func _ready():
	#hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	transparancylevel = player.global_transform.origin.distance_to(global_transform.origin)
	var output = remap(transparancylevel, 0.5, 3, 0, 2.2)
	$Sprite3D.transparency = output
	#print(player.global_transform.origin.distance_to(global_transform.origin))
	
	if player and player.global_transform.origin.distance_to(global_transform.origin) <= visibility_radius:
		#show()
		
		print("show")
	#else:
		#hide()
		#print("hide")



func _on_body_entered(body):
	if body.is_in_group("Climber") && !fotocollected:
		GlobalScript.fotocount += 1
		fotocollected = true
	print("Fotos eingesammelt:",GlobalScript.fotocount)
	pass # Replace with function body.
