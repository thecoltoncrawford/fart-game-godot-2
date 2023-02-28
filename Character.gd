extends KinematicBody2D

var velocity = Vector2.ZERO
export (PackedScene) var next_scene
const GRAVITY = 8

func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	get_tree().change_scene_to(next_scene)
	print("body entered")
