extends Node3D

@onready var transitioncamera = $Camera3D
var transitioning = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func transition_camera3D(from:Camera3D, to: Camera3D, duration: float = 1.0 ) -> void:
	transitioncamera.global_transform = from.global_transform
	transitioncamera.current = true
	transitioning = true
	from = $"../CharacterBody3D/Head/Camera3D"
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Camera3D, "global_transform", to.global_transform, duration).from(Camera3D.global_transform)
	tween.tween_property(Camera3D, "fov", to.fov, duration).from(Camera3D.fov)

	#Wait for the tween to complete
	await tween.finished

	to.current = true
	transitioning = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
