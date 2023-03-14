extends KinematicBody2D

var velocity = Vector2.ZERO
export (String) var next_scene
#var next_scene_load = PackedScene
const GRAVITY = 8

func _ready():
	#next_scene_load = next_scene
	pass


func _physics_process(delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered(body):
	load(next_scene)
	#get_tree().change_scene_to(next_scene)
	get_tree().change_scene(next_scene)
	print("body entered")
