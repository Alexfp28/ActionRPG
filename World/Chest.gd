extends Node2D

export(int) var contador = 0

var is_player_inside = false
var is_opened = false

onready var animation_player = $AnimationPlayer

func _ready():
	animation_player.play("Idle")

func _input(event):
	if event.is_action_pressed("Interact") and is_player_inside and not is_opened:
		is_opened = true
		animation_player.play("Open")


func _on_Area2D_body_entered(player: KinematicBody2D):
	is_player_inside = true
	

func _on_Area2D_body_exited(player: KinematicBody2D):
	is_player_inside = false
