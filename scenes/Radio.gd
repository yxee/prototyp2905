extends Area3D

@onready var collected = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass


func _on_body_entered(body):
	if body.is_in_group("Climber"):
		$AudioStreamPlayer.play()
	if body.is_in_group("Climber") && !collected:
		collected = true
		GlobalScript.radiocount += 1
	print("Radios eingesammelt:",GlobalScript.radiocount)
	pass # Replace with function body.


func _on_body_exited(body):
	if body.is_in_group("Climber"):
		$AudioStreamPlayer.stop()
	pass # Replace with function body.
