extends Area2D

var material_set = false
var _material = null

func _process(delta):
	if $Sprite2D.material != null and material_set == false and _material == null:
		material_set = true
		_material = $Sprite2D.material 
		_material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))

func _on_body_entered(body):
	if body.name == "Player":
		body.nearby_flower = self
		if _material != null:
			_material.set_shader_parameter("line_color", Color(1.0, 1.0, 0.0, 1.0))

func _on_body_exited(body):
	if body.name == "Player":
		if _material != null:
			_material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))
	if body.is_in_group("Player"):
		body.nearby_flower = null
		
