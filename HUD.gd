extends CanvasLayer

signal start_game

var screensize = Vector2(480, 720)

	
func set_cheering_position(position):
	$CheeringRobot.position = position
	

func update_score(value):
	var mins = int(value/60)
	var seconds = (value%60)
	if (seconds < 10):
		seconds = "0" + str(seconds)
	else:
		seconds = str(seconds)
	$MarginContainer/HBoxContainer/ScoreLabel.text = str(mins) + ":" + seconds

func update_battery(value):
	$MarginContainer/HBoxContainer/ChargingProgress.value = value
	
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	


func _on_MessageTimer_timeout():
	$MessageLabel.hide()


func _on_StartButton_pressed():
	$StartButton.hide()
	$MessageLabel.hide()
	emit_signal("start_game")
	
func show_game_over():
	show_message("Game\nOver")
	yield($MessageTimer, "timeout")
	$StartButton.show()
	get_node("../Robot").hide()
	for bomb in get_node("../BombContainer").get_children():
		bomb.queue_free()
	$CheeringRobot.show()
	$MessageLabel.text = ">><<\nRoboRun\n>><<"
	$MessageLabel.show()
	$MarginContainer.hide()
