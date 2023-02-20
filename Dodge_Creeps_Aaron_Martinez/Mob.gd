extends RigidBody2D

var health: int = 1

func _ready():
	$AnimatedSprite.playing = true
	var mob_types = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = mob_types[randi() % mob_types.size()]
	



func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func handle_hit():
	health -= 1
	if health <= 0:
		queue_free()
