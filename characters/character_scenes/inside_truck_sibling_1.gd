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
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))
	$AnimatedSprite2D.material.set_shader_parameter("line_thickness", 22.0)

func _process(delta):
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
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
		if Input.is_action_just_pressed("peck") and can_start_dialogue and !is_chatting:
			print("E pressed, starting dialogue")
			_start_dialogue()
			is_roaming = false
			is_chatting = true
			$AnimatedSprite2D.play("idle")

func _start_dialogue() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))
	var dialogue_line = str(randi_range(1, 2))
	print("Starting dialogue: siblingChick2Random" + dialogue_line)
	var dialog = Dialogic.start("siblingChick2Random" + dialogue_line)
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
	if arg == "exit_sibling1":
		print("signal received")
		InsideTruckGlobal.sibling1_exit = true
		# more code here, check tutorial like around 20 minutes

func choose(array) -> Variant:
	array.shuffle()
	return array.front()
	
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

func move(delta: float) -> void:
	if not is_chatting:
		velocity = dir * speed
		move_and_slide()

func _on_chat_detection_body_entered(body: Node) -> void:
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true
		print("Player entered chat zone")
		if InsideTruckGlobal.sibling1_exit == false:
			$AnimatedSprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 0.0, 1.0))

func _on_chat_detection_body_exited(body: Node) -> void:
	if body.has_method("player"):
		player_in_chat_zone = false
		print("Player exited chat zone")
		$AnimatedSprite2D.material.set_shader_parameter("line_color", Color(1.0, 1.0, 1.0, 0.0))

func _on_timer_timeout() -> void:
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	
