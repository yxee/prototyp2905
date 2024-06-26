extends Node3D

@onready var bubble = $Sprite3D
@onready var anim = $"../AnimationPlayer"
# Called when the node enters the scene tree for the first time.
func _ready():
	bubble.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass





func _on_area_3d_body_entered(body):
	if body.is_in_group("Climber"):
		bubble.show()
		anim.play("Dialogue")
		if GlobalScript.radiocount== 3:
			GlobalScript.radioquest = true
			print(GlobalScript.radioquest)
	pass # Replace with function body.


func _on_area_3d_body_exited(body):
	if body.is_in_group("Climber"):
		bubble.hide()
	pass # Replace with function body.
