extends CharacterBody2D

const speed = 30
var current_state = IDLE

var dir = Vector2.RIGHT
var start_pos

var is_roaming = true
var is_chatting = false

var player
var player_in_chat_zone = false

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func _ready():
	randomize()
	start_pos = position
	#added
	Dialogic.signal_event.connect(DialogicSignal)
	
func _process(delta):
	if current_state == 0 or current_state == 1:
		$AnimatedSprite2D.play("idle")
	elif current_state == 2 and !is_chatting:
		if dir.x == -1:
			$AnimatedSprite2D.play("walking")
		if dir.x == 1:
			$AnimatedSprite2D.play("walking")
		if dir.y == -1:
			$AnimatedSprite2D.play("walking")
		if dir.y == 1:
			$AnimatedSprite2D.play("walking")
	if is_roaming:
		match current_state:
			IDLE:
				pass
			NEW_DIR:
				dir = choose([Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN])
			MOVE:
				move(delta)
	if Input.is_action_pressed("e"):
		print("we're chatting")
		#added
		run_dialogue("siblingChickGiving")
		is_roaming = false
		is_chatting = true
		$AnimatedSprite2D.play("idle")

func run_dialogue(dialogue_string):
	is_chatting = true
	is_roaming = false
	
	Dialogic.start(dialogue_string)
	
func DialogicSignal(arg: String):
	if arg == "exit_chick":
		print("signal received")
		# more code here, check tutorial like around 20 minutes
	
func choose(array):
	array.shuffle()
	return array.front()
	
func move(delta):
	if !is_chatting:
		position += dir * speed * delta
		

func _on_chat_detection_body_entered(body):
	if body.has_method("player"):
		player = body
		player_in_chat_zone = true

func _on_chat_detection_body_exited(body):
	if body.has_method("player"):
		player_in_chat_zone = false

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5,1,1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	

