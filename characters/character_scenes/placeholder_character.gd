extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var isDragging = false;
var push_force = 80;
var inertia = 100;

#func _input(event):
	#if event is InputEventMouseButton:
		#if event.is_pressed() and event.button_index == BUTTON_LEFT:
			#is_dragging = true
		#else:
			#is_dragging = false

func _physics_process(delta):
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "walkRight"
	else:
		sprite_2d.animation = "defaultBob"
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("replayScene"):
		get_tree().reload_current_scene()
	# Handle jump.
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		# if collision and collision.get_collider() is RigidBody2D: 
		#if collision and collision.get_collider().is_in_group("movable_object"):
		if collision and collision.get_collider() is RigidBody2D: 
			collision.get_collider().apply_central_impulse(-collision.get_normal() * push_force)
			print(collision.get_normal() )
			print("hello")
		

	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#if collision.get_collider.is_in_group("movable-object"):
			#collision.collider.apply_central_impulse(-collision.normal + inertia)
		#


	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
func _player():
	pass

	#if is_dragging:
		#var input_vec = Input.get_action_strength("ui_mouse") * Vector2(1, -1)
