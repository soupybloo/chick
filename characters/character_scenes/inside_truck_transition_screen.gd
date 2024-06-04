extends CanvasLayer

var transitioned = false
	
func _process(delta):
	if InsideTruckGlobal.trigger_fall == true and transitioned == false:
		transitioned = true
		transition()
	
func transition():
	$AnimationPlayer.play("fade_to_white")
