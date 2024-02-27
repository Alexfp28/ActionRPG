extends KinematicBody2D

const EnemyDeath = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TARGET_RANGE = 4

enum {
	IDLE,
	WANDER,
	CHASE
}

var speed = Vector2.ZERO
var retroceso = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softcollision = $SoftColision
onready var wanderController = $WanderController

func _ready():
		state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	retroceso = retroceso.move_toward(Vector2.ZERO, 200 * delta)
	retroceso = move_and_slide(retroceso)
	
	match state:
		IDLE:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(rand_range(1, 3))
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			acceleration_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				acceleration_towards_point(player.global_position, delta)
			else:
				state = IDLE
				
	if softcollision.is_colliding():
		speed += softcollision.get_push_vector() * delta * 400
	
	speed = move_and_slide(speed)
	
func acceleration_towards_point(point, delta):
	var direccion = global_position.direction_to(point)
	speed = speed.move_toward(direccion * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = speed.x < 0
	
func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE 
		
func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.vida -= area.damage
	retroceso = area.retroceso_vector * 120
	hurtbox.create_hit_effect()
	
func _on_Stats_sin_vida():
	queue_free()
	var DamageEffect = EnemyDeath.instance()
	get_parent().add_child(DamageEffect)
	DamageEffect.global_position = global_position
