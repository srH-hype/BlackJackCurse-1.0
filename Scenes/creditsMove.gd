extends KinematicBody2D

var velocity = Vector2(0,-140)

func _physics_process(delta):
	move_and_slide(velocity)
	if global_position.y < -1830:
		velocity.y = 0
