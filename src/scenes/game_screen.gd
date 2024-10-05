extends Control

@onready var grid = get_node("CanvasLayer/GridContainer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 100):
		var cell = ColorRect.new()
		cell.color = Color("a58dff")
		cell.custom_minimum_size = Vector2(80, 80)
		grid.add_child(cell)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
