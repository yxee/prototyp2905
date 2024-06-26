extends Control

@onready var score_label = $MarginContainer/AspectRatioContainer/TextureProgressBar/Label
var score = GlobalScript.climbenergy
@onready var player =	$"../../../.."
@onready var finalpoint = $"../../../../../finalpoint"
var transparencylevel = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	$".".hide()
	$ColorRect.color.a = 0
	pass # Replace with function body.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GlobalScript.radiocount== 1:
		$MarginContainer/AspectRatioContainer/TextureRect.texture=ResourceLoader.load("res://assets/textures/textures/Radio1new.png")
	if GlobalScript.radiocount== 2:
		$MarginContainer/AspectRatioContainer/TextureRect.texture=ResourceLoader.load("res://assets/textures/textures/Radio2new.png")
	if GlobalScript.radiocount== 3:
		$MarginContainer/AspectRatioContainer/TextureRect.texture=ResourceLoader.load("res://assets/textures/textures/radio3new.png")
	score_label.text = "Energielevel: " + str(GlobalScript.climbenergy)
	$MarginContainer/AspectRatioContainer/TextureProgressBar.value = GlobalScript.climbenergy
	
	if GlobalScript.fotocount== 1:
		$MarginContainer/AspectRatioContainer/FotoProgress.texture=ResourceLoader.load("res://assets/UI/Foto1.png")
	if GlobalScript.fotocount== 2:
		$MarginContainer/AspectRatioContainer/FotoProgress.texture=ResourceLoader.load("res://assets/UI/Foto2.png")
	if GlobalScript.fotocount== 3:
		$MarginContainer/AspectRatioContainer/FotoProgress.texture=ResourceLoader.load("res://assets/UI/Foto3.png")
	if GlobalScript.fotocount== 4:
		$MarginContainer/AspectRatioContainer/FotoProgress.texture=ResourceLoader.load("res://assets/UI/Foto4.png")
	if GlobalScript.fotocount== 5:
		$MarginContainer/AspectRatioContainer/FotoProgress.texture=ResourceLoader.load("res://assets/UI/Foto5.png")
		
	transparencylevel = player.global_transform.origin.distance_to(finalpoint.global_transform.origin)
	var output = remap(transparencylevel, 0.5, 20, 1, 0)
	
	if GlobalScript.finalarea:
		$ColorRect.color.a = output
	pass



func _on_ridoquest_body_body_entered(body):
	if body.is_in_group("Climber"):
		$".".show()
	pass # Replace with function body.
