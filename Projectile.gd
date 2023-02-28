extends Area2D

enum Directions { LEFT, RIGHT, UP , DOWN }
var direction

var velocity = Vector2.ZERO
const SPEED = 3

func _ready():
	
	# Shoot based on direction
	match direction:
		Directions.LEFT:
			velocity.x = -SPEED
			velocity.y = 0
		Directions.RIGHT:
			velocity.x = SPEED
			velocity.y = 0
		Directions.UP:
			velocity.x = 0
			velocity.y = -SPEED
		Directions.DOWN:
			velocity.x = 0
			velocity.y = SPEED

func _physics_process(delta):
	position += velocity
	

func _on_Projectile_body_entered(body):
	if body.get_name() == "Fart":
		body.restart_level()
	queue_free()


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	queue_free()
