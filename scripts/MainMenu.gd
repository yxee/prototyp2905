extends Control


func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Level_01.tscn")
	#get_tree().change_scene_to_file("res://scenes/TrainRide.tscn")


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/OptionsMenuScene.tscn")

func _on_info_pressed():
	get_tree().change_scene_to_file("res://scenes/InfoMenuScene.tscn")

func _on_exit_pressed():
	get_tree().quit()
	
