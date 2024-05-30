extends CharacterBody2D

#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D

@export var move_speed : float = 300

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



#func _physics_process(delta):
	#if (velocity.x > 1 || velocity.x < -1):
		#sprite_2d.animation = "walkRight"
	#else:
		#sprite_2d.animation = "defaultBob"
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
	#
	#var isLeft = velocity.x < 0
	#sprite_2d.flip_h = isLeft

func player():
	pass

	#if is_dragging:
		#var input_vec = Input.get_action_strength("ui_mouse") * Vector2(1, -1)
		#var mouse_ray = get_viewport().get_camera().project_ray_origin(get_local_mouse_position())
		#var new_pos = mouse_ray.get_origin() + mouse_ray.get_direction() * 2
		#var new_transform = Transform(Basis(), new_pos)
		#set_transform(new_transform)
		#move_and_slide(Vector3(), Vector3.UP)
	


func _on_chat_detection_body_entered(body):
	pass # Replace with function body.


func _on_chat_detection_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	pass # Replace with function body.
