extends Area2D

func _on_body_entered(body):
	
	print(body, "flowerbody")
	if body.name == "Player":
		print("entered")
		body.nearby_flower = self


func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.nearby_flower = null

