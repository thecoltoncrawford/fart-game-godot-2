extends KinematicBody2D

# States
enum States { AIR, FLOOR, WALL, LAUNCH, FLOAT }
var state = States.AIR

# Variables & Constants
var velocity = Vector2(Vector2.ZERO)
var stamina = STAMINA_MAX
var current_level = null
var direction = 0
var degrees = 90 # For launch state
var can_float = false
const STAMINA_MAX = 40
const JUMPFORCE = 200
const LERPAMOUNT = 0.1
const DASH_SPEED = 250
const GRAVITY = 8
const FLOATFORCE = 45
const SPEED = 120
const LAUNCHSPEED = 320

func _ready():
	# Set stamina bar to value set in code
	$StaminaBar.max_value = STAMINA_MAX
	$StaminaWheel.max_value = STAMINA_MAX
	# Get current level (for restarting)
	current_level = get_tree().get_current_scene().get_name() + ".tscn"

func _physics_process(delta):
	
	$StaminaBar.value = stamina
	$StaminaWheel.value = stamina

	match state:
		States.AIR:
			# Switch to Float state
			if can_float:
				if Input.is_action_just_pressed("jump"):
					state = States.FLOAT
			# Switch to Wall state
			if $RayCastWall.is_colliding() and velocity.y > 0:
				state = States.WALL
			# Switch to Floor state
			if is_on_floor():
				state = States.FLOOR
			# Move left and right
			if Input.is_action_pressed("move_right"):
				velocity.x = lerp(velocity.x, SPEED, LERPAMOUNT)
				$Sprite.flip_h = false
			elif Input.is_action_pressed("move_left"):
				velocity.x = lerp(velocity.x, -SPEED, LERPAMOUNT)
				$Sprite.flip_h = true
			else:
				velocity.x = lerp(velocity.x, 0, LERPAMOUNT)
			# Control can_float variable
			if velocity.y > 0:
				can_float = true
			# Variable jump height
			if not Input.is_action_pressed("jump") and velocity.y < 0:
				velocity.y = 0
			set_direction()
			move_and_fall()
			
		States.FLOOR:
			# Switch to air state if falling
			if not is_on_floor():
				state = States.AIR
			# Jump (switch to Air state)
			if Input.is_action_just_pressed("jump"):
				velocity.y = -JUMPFORCE
				state = States.AIR
			# Reset can_float
			can_float = false
			# Increase stamina to maximum amount
			stamina += 1
			if stamina > STAMINA_MAX:
				stamina = STAMINA_MAX
			move_left_right()
			set_direction()
			move_and_fall()
			
		States.WALL:
			# Change states
			if Input.is_action_pressed("jump") and not Input.is_action_pressed("move_left") and not Input.is_action_pressed("move_right"):
				state = States.FLOAT
			if is_on_floor():
				state = States.FLOOR
			elif not $RayCastWall.is_colliding():
				state = States.AIR
			# Wall jump
			if Input.is_action_just_pressed("jump") and ((Input.is_action_pressed("move_left") and direction == 1) or (Input.is_action_pressed("move_right") and direction == -1)):
					velocity.y = -JUMPFORCE
					velocity.x = JUMPFORCE * 0.7 * -direction
			move_and_fall()
			
		States.LAUNCH:
			# Change states
			if $RayCastWall.is_colliding() or is_on_ceiling():
				state = States.AIR
			if is_on_floor():
				state = States.FLOOR
			if Input.is_action_pressed("move_left"):
				$Sprite.flip_h = true
			if Input.is_action_pressed("move_right"):
				$Sprite.flip_h = false
			if Input.is_action_just_pressed("jump"):
					state = States.AIR
			match degrees:
				0.0:
					velocity.x = 0
					velocity.y = -LAUNCHSPEED
					move_and_slide(velocity, Vector2.UP)
					set_direction()
					continue
				90.0:
					velocity.x = LAUNCHSPEED
					velocity.y = 0
					move_and_slide(velocity, Vector2.UP)
					set_direction()
					$Sprite.flip_h = false
					continue
				180.0:
					velocity.x = 0
					velocity.y = LAUNCHSPEED
					move_and_slide(velocity, Vector2.UP)
					set_direction()
					continue
				270.0:
					velocity.x = -LAUNCHSPEED
					velocity.y = 0
					move_and_slide(velocity, Vector2.UP)
					set_direction()
					$Sprite.flip_h = true
					continue
					
		States.FLOAT:
			if $RayCastWall.is_colliding(): #and not Input.is_action_pressed("jump"):
				state = States.WALL
			if stamina <= 0:
				state = States.AIR
			if not Input.is_action_pressed("jump"):
				state = States.AIR
			else:
				if stamina > 0:
					velocity.y = -FLOATFORCE
					stamina -= 1
			# Move left and right
			if Input.is_action_pressed("move_left"):
				velocity.x = lerp(velocity.x, -SPEED, LERPAMOUNT)
			if Input.is_action_pressed("move_right"):
				velocity.x = lerp(velocity.x, SPEED, LERPAMOUNT)
			move_left_right()
			set_direction()
			move_and_fall()


func move_left_right():
	if Input.is_action_pressed("move_left"):
		velocity.x = lerp(velocity.x, -SPEED, LERPAMOUNT)
		$Sprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		velocity.x = lerp(velocity.x, SPEED, LERPAMOUNT)
		$Sprite.flip_h = false
	else:
		velocity.x = lerp(velocity.x, 0, LERPAMOUNT)

func set_direction():
	direction = 1 if not $Sprite.flip_h else -1
	$RayCastWall.rotation_degrees = 90 * -direction

func move_and_fall():
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	# Start fallzone timer
	$FallzoneTimer.start()

func _on_FallzoneTimer_timeout():
	# Resart level
	get_tree().change_scene(current_level)

func restart_level():
	get_tree().change_scene(current_level)

func _on_HazardArea_body_entered(body):
	get_tree().change_scene(current_level)

