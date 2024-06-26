extends Area3D



func _on_body_entered(body):
	print("yuhu")
	if body.is_in_group("Climber"):
		GlobalScript.entry = $Area3D2.global_position
		print("yeleee")
		if body.climbing == false:
			GlobalScript.climbing = true
			print (GlobalScript.climbing)
		
		
		#emit_signal("climbing", true)
	
	pass # Replace with function body.

		
	
		

func _on_body_exited(body):
	if body.is_in_group("Climber"):
		if body.climbing == true:
			GlobalScript.climbing = false
			print (body.climbing)
	pass # Replace with function body.
