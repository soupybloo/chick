extends Area2D

var player
var player_in_chat_zone = false

var can_start_dialogue = true
var dialogue_timeout = 0.5 # Half a second delay

const boundary_size = 20

@onready var anim_tree : AnimationTree = $AnimationTree

var is_shaking = false

func _ready():
	randomize()
	Dialogic.signal_event.connect(DialogicSignal)
	print("Dialogic signal connected")
	#anim_tree.active = true
	#anim_tree["parameters/conditions/is_shaking"] = true
	$AnimatedSprite2D.play("default")
	#$AudioStreamPlayer2D.play()

func _process(delta):
	#update_animation_parameters()
	if InsideTruckGlobal.trigger_noise == true and is_shaking == false:
		#$AudioStreamPlayer2D.play()
		$AnimatedSprite2D.play("shake")
		is_shaking == true
	
	if player_in_chat_zone:
		if Input.is_action_just_pressed("e") and can_start_dialogue and InsideTruckGlobal.trigger_noise == false:
			print("E pressed, starting dialogue")
			_start_dialogue("truck_handle_popup")
			#$AudioStreamPlayer2D.play()
		if Input.is_action_just_pressed("e") and InsideTruckGlobal.trigger_noise ==true:
			print("E pressed, starting transition")
			_start_dialogue("uh_oh_popup")
			#InsideTruckGlobal.trigger_fall = true
			

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
	if InsideTruckGlobal.trigger_noise == true:
		InsideTruckGlobal.trigger_fall = true
	print("Dialogue ended")

func DialogicSignal(arg: String) -> void:
	if arg == "exit_chick":
		print("signal received")

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

