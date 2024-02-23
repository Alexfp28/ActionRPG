extends KinematicBody2D

const EnemyDeath = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

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

func _physics_process(delta):
	retroceso = retroceso.move_toward(Vector2.ZERO, 200 * delta)
	retroceso = move_and_slide(retroceso)
	
	match state:
		IDLE:
			speed = speed.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				var direccion = (player.global_position - global_position).normalized()
				speed = speed.move_toward(direccion * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			sprite.flip_h = speed.x < 0
	speed = move_and_slide(speed)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE 

func _on_Hurtbox_area_entered(area):
	stats.vida -= area.damage
	retroceso = area.retroceso_vector * 120
	hurtbox.create_hit_effect()
	
func _on_Stats_sin_vida():
	queue_free()
	var DamageEffect = EnemyDeath.instance()
	get_parent().add_child(DamageEffect)
	DamageEffect.global_position = global_position
