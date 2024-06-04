extends CharacterBody2D

var is_roaming = true
var is_chatting = false
var player_in_area = false

func _ready():
	#print("null")
	randomize()
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("e"):
			#run dialogue
				run_dialogue("siblingChickGiving")
				
func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	
	Dialogic.start(dialogue_string)
	
func DialogicSignal(arg: String):
	if arg == "exit_chick":
		print("signal received")
		# more code here, check tutorial like around 20 minutes

func _on_chat_detection_body_entered(body):
	if body.has_method("player"):
		player_in_area = true
	pass # Replace with function body.


func _on_chat_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	if body.has_method("player"):
		player_in_area = false
	pass # Replace with function body.
