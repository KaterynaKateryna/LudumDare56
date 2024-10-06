extends CanvasLayer

@onready var color_rect = get_node("ColorRect")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#var tween = get_tree().create_tween().set_loops()
	#var time = 5
	#tween.tween_property(color_rect, "modulate", Color("fad9c4"), time)
	#tween.tween_property(color_rect, "modulate", Color("f2e0a1"), time)
	#tween.tween_property(color_rect, "modulate", Color("a7f7b6"), time)
	#tween.tween_property(color_rect, "modulate", Color("83f8e9"), time)
	#todo choose nicer colors


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
