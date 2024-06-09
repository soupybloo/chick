extends Node2D

var totalFlowers = 3
var startEnd = false

func _process(delta):
	if totalFlowers == 1:
		startEnd = true
