extends KinematicBody2D

const Acceleration = 500
const Max_speed = 80
const Friction = 500

var speed = Vector2.ZERO

onready var animationPlayer = $AnimationPlayer

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x > 0:
			animationPlayer.play("RunRight")
		else:
			animationPlayer.play("RunLeft")
		speed = speed.move_toward(input_vector * Max_speed, Acceleration * delta)
	else:
		animationPlayer.play("IdleRight")
		speed = speed.move_toward(Vector2.ZERO, Friction * delta)
	
	speed = move_and_slide(speed)
		 
