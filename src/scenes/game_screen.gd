extends Control

@onready var grid = get_node("CanvasLayer/GridContainer")

@onready var tiny_creature_scene = load("res://scenes/tiny_creature.tscn")

var rng = RandomNumberGenerator.new()
var cell_edge_size = 100
var cell_edge_center = cell_edge_size / 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 100):
		var cell = ColorRect.new()
		cell.color = Color("a58dff")
		cell.custom_minimum_size = Vector2(cell_edge_size, cell_edge_size)
		grid.add_child(cell)
		var creature = _get_random_creature()
		if creature != null:
			creature.size = cell.custom_minimum_size * 0.8
			creature.position = Vector2(cell_edge_center, cell_edge_center)
			cell.add_child(creature)
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _get_random_creature():
	var rand = rng.randi_range(0, 2)
	if rand < 2:
		return null #no creature
	
	var colour
	var rand_colour = rng.randi_range(0, 2)
	if rand_colour == 0:
		colour = Color.MEDIUM_VIOLET_RED
	elif rand_colour == 1:
		colour = Color.AQUAMARINE
	elif rand_colour == 2:
		colour = Color.DEEP_SKY_BLUE
	
	var tiny_creature = tiny_creature_scene.instantiate()
	tiny_creature.colour = colour
	return tiny_creature
