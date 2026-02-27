extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout
	$MessageLabel.text = "Vuelve a\nintentarlo"
	$MessageLabel.show()
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()


func update_score(score):
	$ScoreLabel.text = str(score)


func _on_StartButton_pressed():
	$StartButton.hide()
	start_game.emit()


func _on_MessageTimer_timeout():
	$MessageLabel.hide()

@export var heart_texture: Texture2D

func update_lives(lives):
	print("Textura:", heart_texture)
	var container = $LivesContainer
	for child in container.get_children():
		child.queue_free()
	for i in range(lives):
		var heart = TextureRect.new()
		heart.texture = heart_texture
		heart.custom_minimum_size = Vector2(22,22)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(heart)

	
func hide_message():
	$MessageLabel.hide()
	$StartButton.hide()
	
