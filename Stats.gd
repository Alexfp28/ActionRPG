extends Node2D

export(int) var maxima_vida = 1
onready var vida = maxima_vida setget set_vida

signal sin_vida

func set_vida(value):
	vida = value
	if vida <= 0:
		emit_signal("sin_vida")
