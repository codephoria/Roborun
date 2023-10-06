extends Area2D

signal pickup
signal hurt

var speed = 400
var velocity = Vector2()
var screensize = Vector2(480, 720)



func _process(delta):
	get_input()
	position += velocity * delta
	position.x = clamp(position.x, 0 + $AnimatedSprite.frames.get_frame("walk", 0).get_width()/3, screensize.x - $AnimatedSprite.frames.get_frame("walk", 0).get_width()/3)
	position.y = clamp(position.y, 0 + $AnimatedSprite.frames.get_frame("walk", 0).get_height()/3, screensize.y - $AnimatedSprite.frames.get_frame("walk", 0).get_height()/3)
	if velocity.length() > 0:
		if speed > 200:
			$AnimatedSprite.animation = "run"
		else:
			$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "idle"



func start(pos):
	set_process(true)
	position = pos
	speed = 400
	$AnimatedSprite.animation = "idle"


func die():
	$AnimatedSprite.animation = "die"
	set_process(false)




func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed


func _on_Robot_area_entered(area):
	if area.is_in_group("power"):
		area.pickup()
		emit_signal("pickup")
	if area.is_in_group("enemy"):
		emit_signal("hurt")
		area.move_from_screen(velocity)
