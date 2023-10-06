extends Area2D


var screensize = Vector2()

var speed = 800
var velocity = Vector2()
var activated = false

func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1,1,1,1), Color(1,0.5,0.5,1), 3,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween2.interpolate_property($AnimatedSprite, 'modulate', Color(1,0.5,0.5,1), Color(1,1,1,1), 0.1,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	
func _process(delta):
	position += velocity * delta
	if !activated and $ExplosionTimer.time_left <= 3:
		activated = true
		$Tween.start()
	

func _on_ExplosionTimer_timeout():
	velocity = Vector2(0,0)
	$AnimatedSprite.animation = "explode"
	get_node("../../Robot").die()
	get_node("../..").game_over()
	
func move_from_screen(direction):
	velocity = direction.normalized() * speed


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Tween_tween_completed(object, key):
	$Tween2.start()
