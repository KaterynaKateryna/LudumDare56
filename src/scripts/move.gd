extends Node

var move_type: Enums.MOVE_TYPE

var creature:
	set(value):
		if move_type == Enums.MOVE_TYPE.CREATURE:
			creature = value
			
var card:
	set(value):
		if move_type == Enums.MOVE_TYPE.CARD:
			card = value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _init(type: Enums.MOVE_TYPE):
	self.move_type = type
	
