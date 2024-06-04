extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.nearby_flower = self


func _on_body_exited(body):
	if body.is_in_group("Player"):
		body.nearby_flower = null

