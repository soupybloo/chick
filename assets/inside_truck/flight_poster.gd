extends Area2D

var player
var player_in_chat_zone = false

var can_start_dialogue = true
var dialogue_timeout = 0.5 # Half a second delay

const boundary_size = 20

func _ready():
	randomize()
	Dialogic.signal_event.connect(DialogicSignal)
	print("Dialogic signal connected")

func _process(delta):
	if player_in_chat_zone:
		if Input.is_action_just_pressed("peck") and can_start_dialogue:
			print("E pressed, starting dialogue")
			_start_dialogue("flight_poster_popup")

func _start_dialogue(dialogue_string) -> void:
	var dialog = Dialogic.start(dialogue_string)
	add_child(dialog)
	dialog.visible = true
	Dialogic.timeline_ended.connect(ended_dialogue)
	can_start_dialogue = false
	await get_tree().create_timer(dialogue_timeout).timeout
	can_start_dialogue = true

func ended_dialogue() -> void:
	Dialogic.timeline_ended.disconnect(ended_dialogue)
	print("Dialogue ended")

func DialogicSignal(arg: String) -> void:
	if arg == "exit_flight_poster":
		print("signal received")
		InsideTruckGlobal.flight_poster_exit = true

func choose(array) -> Variant:
	array.shuffle()
	return array.front()

func _on_chat_detection_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true


func _on_chat_detection_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false
