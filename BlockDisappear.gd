extends Area2D



func _on_BlockDisappear_body_entered(body):
	$Timer.start()

func _on_Timer_timeout():
	$StaticBody2D/CollisionShape2D.set_deferred("disabled", true)
	$Sprite.visible = false
