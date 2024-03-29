extends KinematicBody2D

export var Acceleration = 500
export var Max_speed = 80
export var ROLL_SPEED = 125
export var Friction = 500

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var speed = Vector2.ZERO
var roll_vector = Vector2.DOWN
var stats = PlayerStats

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox

func _ready():
	randomize()
	stats.connect("sin_vida", self, "queue_free")
	animationTree.active = true
	swordHitbox.retroceso_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
		 move_state(delta)
		
		ROLL:
		 roll_state(delta)
		
		ATTACK:
		 attack_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.retroceso_vector = input_vector
		animationTree.set("parameters/Inactivo/blend_position", input_vector)
		animationTree.set("parameters/Correr/blend_position", input_vector)
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		animationState.travel("Correr")
		speed = speed.move_toward(input_vector * Max_speed, Acceleration * delta)
	else:
		animationState.travel("Inactivo")
		speed = speed.move_toward(Vector2.ZERO, Friction * delta)
	
	move()
	
	if Input.is_action_pressed("roll"):
		state = ROLL
	
	if Input.is_action_pressed("attack"):
		state = ATTACK

func roll_state(delta):
	speed = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()

func attack_state(delta):
	speed = Vector2.ZERO
	animationState.travel("Attack")
	
func move():
		speed = move_and_slide(speed)

func roll_animation_finished():
	speed = speed * 0.8
	state = MOVE
	
func attack_animation_finished():
	state = MOVE

func _on_Hurtbox_area_entered(area):
	stats.vida -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
