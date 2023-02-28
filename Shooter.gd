extends StaticBody2D

enum Directions { LEFT, RIGHT, UP, DOWN }
export var direction = Directions.LEFT
export var shoot_time = 1.0
export var start_delay = 0.0
var timer = 0
var my_position = Vector2(position.x, position.y)
var projectile_scene = preload("res://Projectile.tscn")

func _ready():
	timer = -start_delay

func _physics_process(delta):
	timer += delta
	if timer >= shoot_time:
		shoot()
		timer = 0

func shoot():
	var new_projectile = projectile_scene.instance()
	new_projectile.direction = direction
	new_projectile.position = my_position
	add_child(new_projectile)
	






