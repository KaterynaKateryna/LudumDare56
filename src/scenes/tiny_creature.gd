extends Node2D

@export var colour: Color
@export var size: Vector2

@onready var shape = get_node("Shape")
@onready var check = get_node("Shape/check")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if colour != null:
		shape.modulate = colour
		check.modulate = Color(0, 255, 0)
	if size != null:
		shape.scale.x = size.x / shape.texture.get_width()
		shape.scale.y = size.y / shape.texture.get_height()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
