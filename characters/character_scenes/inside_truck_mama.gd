extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

var can_start_dialogue = true
var dialogue_timeout = 0.5 # Half a second delay

var trigger_once = false

const boundary_size = 20

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	Dialogic.signal_event.connect(DialogicSignal)
	print("Dialogic signal connected")
	$truck_noise.play()

func _process(delta):
	if InsideTruckGlobal.trigger_noise == true and trigger_once == false:
		trigger_once = true
		print("i start the noise dialogue")
		$AudioStreamPlayer.play()
		await get_tree().create_timer(2).timeout
		_start_dialogue("handle_noise")
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1 or dir.x == 1 or dir.y == -1 or dir.y == 1:
			$AnimatedSprite2D.play("walking")
	
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
				check_boundaries()
	
	if player_in_chat_zone:
		if Input.is_action_just_pressed("e") and can_start_dialogue and !is_chatting:
			print("E pressed, starting dialogue")
			_start_dialogue("siblingChickGiving")
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle")

func _start_dialogue(dialogue_string) -> void:
	print(dialogue_string)
	var dialog = Dialogic.start(dialogue_string)
	add_child(dialog)
	dialog.visible = true
	Dialogic.timeline_ended.connect(ended_dialogue)
	can_start_dialogue = false
	await get_tree().create_timer(dialogue_timeout).timeout
	can_start_dialogue = true

func ended_dialogue() -> void:
	Dialogic.timeline_ended.disconnect(ended_dialogue)
	is_chatting = false
	is_roaming = true
	print("Dialogue ended")

func DialogicSignal(arg: String) -> void:
	if arg == "exit_mama":
		print("signal received")
		InsideTruckGlobal.mama_exit = true
		# more code here, check tutorial like around 20 minutes

func choose(array) -> Variant:
	array.shuffle()
	return array.front()

func move(delta: float) -> void:
	if not is_chatting:
		velocity = dir * speed
		move_and_slide()
		#position += dir * speed * delta
		
func check_boundaries() -> void:
	if position.x < start_pos.x - boundary_size:
		position.x = start_pos.x - boundary_size
		current_state = NEW_DIR
	elif position.x > start_pos.x + boundary_size:
		position.x = start_pos.x + boundary_size
		current_state = NEW_DIR
	if position.y < start_pos.y - boundary_size:
		position.y = start_pos.y - boundary_size
		current_state = NEW_DIR
	elif position.y > start_pos.y + boundary_size:
		position.y = start_pos.y + boundary_size
		current_state = NEW_DIR

func _on_chat_detection_body_entered(body: Node) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_body_exited(body: Node) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])


	

