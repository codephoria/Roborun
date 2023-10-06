extends Node

export (PackedScene) var Powerup
export (PackedScene) var Bomb
export (float) var battery

var level = 0
var score = 0
var screensize
var playing = false


func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$StartPosition.position.x = int(screensize.x/2)
	$StartPosition.position.y = 150
	$Robot.screensize = screensize
	$HUD.screensize = screensize
	$HUD.set_cheering_position($StartPosition.position)
	$Robot.hide()
	$HUD/CheeringRobot.show()

	

func new_game():
	playing = true
	level = 1
	score = 0
	battery = 100
	$HUD/CheeringRobot.hide()
	$Robot.start($StartPosition.position)
	$Robot.show()
	$BatteryTimer.start()
	$PowerupTimer.wait_time = rand_range(3, 8)
	$PowerupTimer.start()
	$BombTimer.wait_time = rand_range(0, 1)
	$BombTimer.start()
	$ScoreTimer.start()
	$HUD/MarginContainer.show()
	$HUD/MarginContainer/HBoxContainer/ChargingProgress.value = battery
	
	
func spawn_power():
	for _i in range (rand_range(1, 3)):
		var p = Powerup.instance()
		$PowerupContainer.add_child(p)
		p.screensize = screensize
		p.position = Vector2(rand_range(0 + p.get_node("AnimatedSprite").frames.get_frame("default", 0).get_width()/3, 
		screensize.x - p.get_node("AnimatedSprite").frames.get_frame("default", 0).get_width()/3), 
		rand_range(0  + p.get_node("AnimatedSprite").frames.get_frame("default", 0).get_height()/3, 
		screensize.y - p.get_node("AnimatedSprite").frames.get_frame("default", 0).get_height()/3))

func spawn_bomb():
	for _i in range (rand_range(1, level * 2)):
		var b = Bomb.instance()
		$BombContainer.add_child(b)
		b.screensize = screensize
		b.position = Vector2(rand_range(0 + b.get_node("AnimatedSprite").frames.get_frame("default", 0).get_width()/3, 
		screensize.x - b.get_node("AnimatedSprite").frames.get_frame("default", 0).get_width()/3), 
		rand_range(0  + b.get_node("AnimatedSprite").frames.get_frame("default", 0).get_height()/3, 
		screensize.y - b.get_node("AnimatedSprite").frames.get_frame("default", 0).get_height()/3))

func _process(_delta):
	
	if (battery < 50 and playing):
		$Robot.speed = 200
	
	if (battery <= 0 and playing):
		game_over()
	
	
		


func game_over():
	playing = false
	$PowerupTimer.stop()
	$BatteryTimer.stop()
	$BombTimer.stop()
	$ScoreTimer.stop()
	for powerup in $PowerupContainer.get_children():
		powerup.queue_free()
	$Robot.die()
	$HUD.show_game_over()

	
	


func _on_PowerupTimer_timeout():
	spawn_power()
	$PowerupTimer.wait_time = rand_range(1,3)
	$PowerupTimer.start()


func _on_BatteryTimer_timeout():
	if $Robot.velocity.length() > 0:
		battery -= 1
	else:
		battery -= 0.5
	$HUD/MarginContainer/HBoxContainer/ChargingProgress.value = battery


func _on_Robot_pickup():
	battery += 20
	if battery > 100:
		battery = 100
	if battery >= 50:
		$Robot.speed = 400
	$HUD/MarginContainer/HBoxContainer/ChargingProgress.value = battery


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)
	if (score % 15) == 0:
		level += 1


func _on_BombTimer_timeout():
	spawn_bomb()
	$BombTimer.wait_time = rand_range(2, 4)
	$BombTimer.start()
