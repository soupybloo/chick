extends CanvasLayer

var transitioned = false
	
func _process(delta):
	if InsideTruckGlobal.trigger_fall == true and transitioned == false:
		transitioned = true
		transition()
	
func transition():
	#$AnimationPlayer.play("fade_to_white")
	$VideoStreamPlayer.play()
	
	


func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://scenes/3.caterpillar_scene.tscn")
	# something something load video.
