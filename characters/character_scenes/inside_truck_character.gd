extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D

@export var move_speed : float = 300

var canIdle = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)

	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "walkRight"
		if velocity.x < -1:
			sprite_2d.flip_h = true
		elif velocity.x > 1:
			sprite_2d.flip_h = false
	elif (velocity.y > 1 || velocity.y < -1):
		sprite_2d.animation = "walkRight"
	else:
		sprite_2d.animation = "defaultBob"

	# Update velocity
	velocity = input_direction * move_speed

	# Move character on map
	move_and_slide()
	
	if Input.is_action_just_pressed("peck"):
		print("pecking")
		sprite_2d.animation = "peck"
	

func player():
	pass


func _on_chat_detection_body_entered(body):
	pass # Replace with function body.


func _on_chat_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.

