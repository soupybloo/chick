extends CanvasLayer

var transitioned = false
	
func _process(delta):
	if InsideTruckGlobal.trigger_fall == true and transitioned == false:
		transitioned = true
		transition()
	
func transition():
	#$AnimationPlayer.play("fade_to_white")
	$VideoStreamPlayer.play()
	
	

func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/inside_truck.tscn")
	 # Replace with function body.
