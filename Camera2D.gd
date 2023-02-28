extends Camera2D

const MAX_Y_OFFSET = 15
var starting_offset = 0
var move_speed = 0.08


func _ready():
	starting_offset = offset.y

func _physics_process(delta):
	
	if Input.is_action_pressed("camera_down"):
		offset.y = lerp(offset.y, MAX_Y_OFFSET, move_speed)
		pass
	else:
		offset.y = lerp(offset.y, starting_offset, move_speed)

