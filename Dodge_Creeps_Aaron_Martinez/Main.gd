extends Node

export(PackedScene) var mob_scene
var score

func _ready():
	randomize()
	$Player.connect("player_fired_bullet",bullet_manager,"handle_bullet_spawned")
	
onready var bullet_manager = $BulletManager



func game_over():
	$Music.stop()
	$DeathMusic.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	
func new_game():
	get_tree().call_group("mobs","queue_free")
	$Music.play()
	score = 0
	$HUD.update_score(score)
	$HUD.show_message("Get Ready.\nShoot with Space.\nSurvive.")
	$Player.start($StartPosition.position)
	$StartTimer.start()


func _on_MobTimer_timeout():
	var mob = mob_scene.instance()
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	
	var direction = mob_spawn_location.rotation + PI / 2
	mob.position = mob_spawn_location.position
	
	direction += rand_range(-PI/4,PI/4)
	mob.rotation = direction
	
	var velocity = Vector2(rand_range(150.0,250.0),0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_start_game():
	pass # Replace with function body.
