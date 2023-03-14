extends KinematicBody2D

const MOVE_SPEED = 1.2
var dir = 1
var last_dir = dir
var counter = 0
enum DIRECTIONS { up, down }
export(DIRECTIONS) var start_direction = DIRECTIONS.up
export var move_distance: int = 8
export var pause_time: float = 1.0

func _ready():
	dir = -1 if start_direction == DIRECTIONS.up else 1
	last_dir = dir
	
	move_distance *= 8

	$Timer.wait_time = pause_time

func _physics_process(delta):
	if (dir != 0):
		counter += MOVE_SPEED
	
	if counter >= abs(move_distance):
		counter = 0
		if dir == 1:
			last_dir = dir
			dir -= 1
			$Timer.start()
		elif dir == -1:
			last_dir = dir
			dir += 1
			$Timer.start()
		else:
			if last_dir == -1:
				dir += 1
			elif last_dir == 1:
				dir -= 1
		
	position.y += MOVE_SPEED * dir
	print(dir)

func _on_Timer_timeout():
	if last_dir == -1:
		dir += 1
		$Timer.stop()
	elif last_dir == 1:
		dir -= 1
		$Timer.stop()
