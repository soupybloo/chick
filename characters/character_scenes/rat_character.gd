extends CharacterBody2D

var player_in_area = false
var player_chatting = false
var has_chatted = false
var dialogue_timeout = 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready():
	$Sprite2D/AnimationPlayer.play("idle_rat")
	$Sprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 0.0, 1.0))
	$Sprite2D.material.set_shader_parameter("line_thickness", 1.0)
	
	

func _process(delta):
	if player_in_area:
		if Input.is_action_just_pressed("peck") and !player_chatting:
			player_chatting = true
			if !has_chatted:
				has_chatted = true
				_start_dialogue("rat_popup1")

	
	
func _start_dialogue(dialogue_string) -> void:
	$Sprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))
	print(dialogue_string)
	var dialog = Dialogic.start(dialogue_string)
	add_child(dialog)
	dialog.visible = true
	Dialogic.timeline_ended.connect(ended_dialogue)
	await get_tree().create_timer(dialogue_timeout).timeout

func ended_dialogue() -> void:
	Dialogic.timeline_ended.disconnect(ended_dialogue)
	player_chatting = false
	print("Dialogue ended")

func _on_chat_detection_box_body_entered(body):
	player_in_area = true
	if body.has_method("player"):
		print("in here")
		if !has_chatted:
			player_in_area = true


func _on_chat_detection_box_body_exited(body):
	player_in_area = false
