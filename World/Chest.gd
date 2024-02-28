extends Node2D

export(int) var contador = 1

const ChestEffect = preload("res://Effects/ChestEffect.tscn")

var is_player_inside = false
var is_opened = false

var eventSelf = InputEvent
var player = KinematicBody2D

onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")
	
func create_chest_effect():
		var grassEffect = ChestEffect.instance()
		get_parent().add_child(grassEffect)
		grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
	if (PlayerStats.vida < 4):
		PlayerStats.vida += 1
		
	elif (PlayerStats.vida > 4):
		
		PlayerStats.maxima_vida += 1
		PlayerStats.vida += 1
	create_chest_effect()
	queue_free()


func _on_Hurtbox_area_exited(area):
	is_player_inside = false
