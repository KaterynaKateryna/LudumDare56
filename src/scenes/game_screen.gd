extends Control

@onready var grid = get_node("CanvasLayer/GridContainer")
@onready var next_move_placeholder = get_node("CanvasLayer/VBoxContainer/NextMovePlaceholder")

@onready var tiny_creature_scene = load("res://scenes/tiny_creature.tscn")
@onready var move = load("res://scripts/move.gd")

var rng = RandomNumberGenerator.new()
var cell_edge_size = 100
var cell_edge_center = cell_edge_size / 2
var next_move

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, 100):
		var cell = ColorRect.new()
		cell.color = Color("a58dff")
		cell.custom_minimum_size = Vector2(cell_edge_size, cell_edge_size)
		grid.add_child(cell)
		var creature = _get_random_creature_maybe()
		if creature != null:
			creature.size = cell.custom_minimum_size * 0.8
			creature.position = Vector2(cell_edge_center, cell_edge_center)
			cell.add_child(creature)
			
	next_move = _get_random_next_move()
	_display_next_move()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _get_random_creature_maybe():
	var rand = rng.randi_range(0, 2)
	if rand < 2:
		return null #no creature
	
	return _get_random_creature()
	
func _get_random_creature():
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

func _get_random_next_move():
	var rand = rng.randi_range(0, 1)
	
	if rand == 0:
		print("creature")
		var result = move.new(Enums.MOVE_TYPE.CREATURE)
		result.creature = _get_random_creature()
		return result
	if rand == 1:
		print("submit")
		return move.new(Enums.MOVE_TYPE.SUBMIT)
		
func _display_next_move():
	var children_count = next_move_placeholder.get_child_count()
	if children_count != 0:
		next_move_placeholder.get_children().clear()
	
	var placeholder_center = Vector2(next_move_placeholder.size.x / 2, next_move_placeholder.size.y / 2)
	if next_move.move_type == Enums.MOVE_TYPE.CREATURE:
		next_move.creature.size = next_move_placeholder.size * 0.8
		next_move.creature.position = placeholder_center
		next_move_placeholder.add_child(next_move.creature)
		
	elif next_move.move_type == Enums.MOVE_TYPE.SUBMIT:
		var submit_button = Button.new()
		#submit_button.position = placeholder_center
		submit_button.text = "Submit"
		next_move_placeholder.add_child(submit_button)
		
		
