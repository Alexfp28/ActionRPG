extends Node2D

export(int) var maxima_vida = 1 setget set_max_vida
var vida = maxima_vida setget set_vida

signal sin_vida
signal vida_changed(value)
signal max_vida_changed(value)

func set_max_vida(value):
	maxima_vida = value
	self.vida = min(vida, maxima_vida)
	emit_signal("max_vida_changed", maxima_vida)

func set_vida(value):
	vida = value
	emit_signal("vida_changed", vida)
	if vida <= 0:
		emit_signal("sin_vida")
		
func _ready():
	self.vida = maxima_vida
