extends Control


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/MenuScene.tscn")



func _on_website_pressed():
	OS.shell_open("https://www.ende-gelaende.org")
	pass # Replace with function body.


func _on_website_2_pressed():
	OS.shell_open("https://teslastoppen.noblogs.org")
	pass # Replace with function body.
