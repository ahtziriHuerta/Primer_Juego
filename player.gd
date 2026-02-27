extends Area2D

signal hit
signal player_died

@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var invulnerable = false

func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "right"
	hide()


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed(&"move_right"):
		velocity.x += 1
	if Input.is_action_pressed(&"move_left"):
		velocity.x -= 1
	if Input.is_action_pressed(&"move_down"):
		velocity.y += 1
	if Input.is_action_pressed(&"move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

	if velocity.x > 0:
		$AnimatedSprite2D.animation = &"right"
	elif velocity.x < 0:
		$AnimatedSprite2D.animation = &"left"

	elif velocity.y > 0:
		$AnimatedSprite2D.animation = &"down"

	elif velocity.y < 0:
		$AnimatedSprite2D.animation = &"up"

func start(pos):
	position = pos
	rotation = 0
	show()

	set_process(true)
	$CollisionShape2D.set_deferred("disabled", false)

	$AnimatedSprite2D.animation = "right"
	$AnimatedSprite2D.stop()

	invulnerable = true
	blink()

	await get_tree().create_timer(1.5).timeout
	invulnerable = false
	
func blink():
	for i in 6:
		visible = false
		await get_tree().create_timer(0.1).timeout
		visible = true
		await get_tree().create_timer(0.1).timeout


func _on_body_entered(_body):
	if invulnerable:
		return

	invulnerable = true
	$CollisionShape2D.set_deferred("disabled", true)
	set_process(false)
	emit_signal("player_died")
	$AnimatedSprite2D.play("die")



