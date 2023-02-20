extends Area2D
signal hit
signal player_fired_bullet(bullet, position, direction)

export (PackedScene) var Bullet
export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

onready var end_of_gun = $EndOfGun

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		$AnimatedSprite.play("right")
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite.play("left")
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		$AnimatedSprite.play("down")
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		$AnimatedSprite.play("up")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		#$AnimatedSprite.play() #$ is short hand for get_node() 
	else:						# $AnimatedSprite = get_node("AnimatedSprite").play()
		$AnimatedSprite.stop()
	position += velocity * delta	#delta variable built in; avoids frame time lag issues
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	#this is shorter than the alternative:
	#if velocity.x < 0:
	#	$AnimatedSprite.flip_h = true
	#else:
	#	$AnimatedSprite.flip_h = false
	
	#the alternative:
	#if velocity.x != 0:
		#$AnimatedSprite.animation = "walk"
		#$AnimatedSprite.flip_v = false
	# See the note below about boolean assignment.
		#$AnimatedSprite.flip_h = velocity.x < 0
	#elif velocity.y != 0:
		#$AnimatedSprite.animation = "up"
		#$AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
func _unhandled_input(event: InputEvent):
	if event.is_action_released("shoot"):
		shoot()
	
func shoot():
	var bullet_instance = Bullet.instance()
	bullet_instance.global_position = end_of_gun.global_position
	var target = get_global_mouse_position()
	var direction_to_mouse = end_of_gun.global_position.direction_to(target).normalized()
	bullet_instance.set_direction(direction_to_mouse)
	emit_signal("player_fired_bullet",bullet_instance, end_of_gun.position, direction_to_mouse)
