extends Area2D

@export var speed = 200 #speed of chick
var screen_size



# Called when the node enters the scene tree for the first time.
#func _ready():
	#screenSize = get_viewport_rect().size
	#hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	screen_size = get_viewport_rect().size
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("jump"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	if velocity.x != 0:
			$AnimatedSprite2D.animation = "moveRight"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.x == 0 or velocity.y == 0:
		$AnimatedSprite2D.animation = "standStill"
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "standStill"
		$AnimatedSprite2D.flip_v = velocity.y > 0

			
