extends Node2D

var mama_exit = false
var sibling1_exit = false
var sibling2_exit = false
var sibling3_exit = false
var sibling4_exit = false
var chicken_feed_exit = false
var flight_poster_exit = false
var stacked_crates_exit = false

var trigger_noise = false

func _process(delta):
	if mama_exit == true and sibling1_exit == true and sibling2_exit == true and sibling3_exit == true and sibling4_exit == true and chicken_feed_exit == true and flight_poster_exit == true and stacked_crates_exit == true:
		trigger_noise = true




