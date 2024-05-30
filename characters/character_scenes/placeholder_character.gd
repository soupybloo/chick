extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D
var nearby_flower = null

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _input(event):
	if event.is_action("peck"):
		print("okay")
		print(nearby_flower)
	if event.is_action_pressed("peck") and nearby_flower:
		print("done")
		pluck_flower()

func _physics_process(delta):
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "walkRight"
	else:
		sprite_2d.animation = "defaultBob"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#Handle peck
	if Input.is_action_pressed("peck"):
		sprite_2d.animation = "explorePeck"
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func pluck_flower():
	if nearby_flower:
		nearby_flower.queue_free()
		nearby_flower = null
		
func _on_Area2D_body_entered(body):
	print("body", body)
	if body.name == "Flower":
		nearby_flower = body

func _on_Area2D_body_exited(body):
	if body == nearby_flower:
		nearby_flower = null
