extends Area2D

export var time = 1
export var rotates = true
enum Directions { LEFT, RIGHT, UP, DOWN }
export var direction = Directions.LEFT

func _ready():
	if rotates:
		$Timer.wait_time = time
		$Timer.start()
	else:
		match direction:
			Directions.LEFT:
				rotation_degrees = 270.0
				continue
			Directions.RIGHT:
				rotation_degrees = 90.0
				continue
			Directions.UP:
				rotation_degrees = 0.0
				continue
			Directions.DOWN:
				rotation_degrees = 180.0
	

func _on_Timer_timeout():
	rotation_degrees += 90
	if rotation_degrees >= 360:
		rotation_degrees = 0

func _on_FartLauncher_body_entered(body):
	body.position = position
	body.degrees = rotation_degrees
	body.state = 3
