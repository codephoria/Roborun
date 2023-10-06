extends Area2D


var screensize = Vector2()

func pickup():
	$CollisionShape2D.set_deferred("disabled", true) # or monitoring false in _ready
	$Tween.start()


func _ready():
	$Tween.interpolate_property($AnimatedSprite, 'scale', $AnimatedSprite.scale, $AnimatedSprite.scale * 2, 0.3,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($AnimatedSprite, 'modulate', Color(1,1,1,1), Color(1,1,1,0), 0.3,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$SelfDestructionTimer.wait_time = rand_range(3, 8)
	$SelfDestructionTimer.start()



func _on_SelfDestructionTimer_timeout():
	queue_free()


func _on_Tween_tween_completed(object, key):
	queue_free()
