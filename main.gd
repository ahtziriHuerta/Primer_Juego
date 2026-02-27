extends Node

@export var mob_scene: PackedScene
var score
var lives = 3

#func game_over():
#	$ScoreTimer.stop()
#	$MobTimer.stop()
#	$HUD.show_game_over()
#	$Music.stop()
#	$DeathSound.play()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$DeathSound.play()
	$Music.stop()
	await get_tree().create_timer(2.0).timeout
	new_game()
	


func new_game():
	score = 0
	lives = 3

	$HUD.update_score(score)
	$HUD.update_lives(lives)
	$Music.play()
	$Player.start($StartPosition.position)
	$StartTimer.start()
	


func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = get_node(^"MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _ready():
	$Player.player_died.connect(_on_player_died)

func _on_player_died():
	print("VIDA PERDIDA")
	lives -= 1
	print("VIDAS:", lives)

	$HUD.update_lives(lives)

	if lives <= 0:
		game_over()
	else:
		$Player.start($StartPosition.position)



	
