extends Control

@onready var main = $"../../../../.."

func _on_resume_pressed():
	main.pauseMenu()
	
func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/OptionsMenuScene.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/MenuScene.tscn")
	Engine.time_scale = 1

func _on_exit_pressed():
	get_tree().quit()
