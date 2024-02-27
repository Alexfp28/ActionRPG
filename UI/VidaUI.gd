extends Control

var corazones = 4 setget set_corazones
var max_corazones = 4 setget set_max_corazones

onready var label = $Label
onready var corazonUIEmpty = $CorazonUIEmpty
onready var corazonUIFull = $CorazonUIFull

func set_corazones(value):
	corazones = clamp(value, 0, max_corazones)
	if corazonUIFull != null:
		corazonUIFull.rect_size.x = corazones * 15
	
func set_max_corazones(value):
	max_corazones = max(value, 1)
	self.corazones = min(corazones, max_corazones)
	if corazonUIEmpty != null:
		corazonUIEmpty.rect_size.x = max_corazones * 15
	
func _ready():
	self.max_corazones = PlayerStats.maxima_vida
	self.corazones = PlayerStats.vida
	PlayerStats.connect("vida_changed", self, "set_corazones")
	PlayerStats.connect("max_vida_changed", self, "set_max_corazones")
