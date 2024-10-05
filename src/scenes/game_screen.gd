extends Control

@onready var grid = get_node("CanvasLayer/GridContainer")
@onready var cards_container = get_node("CanvasLayer/BottomContainer/CardsContainer")
@onready var next_move_placeholder = get_node("CanvasLayer/VBoxContainer/NextMovePlaceholder")
@onready var submit_button = get_node("CanvasLayer/BottomContainer/SubmitButton")
@onready var score_value_label = get_node("CanvasLayer/VBoxContainer/ScoreValueLabel")

@onready var tiny_creature_scene = load("res://scenes/tiny_creature.tscn")
@onready var card_scene = load("res://scenes/card.tscn")
@onready var cell_scene = load("res://scenes/cell.tscn")
@onready var move = load("res://scripts/move.gd")

var rng = RandomNumberGenerator.new()
var cell_edge_size = 100
var cell_edge_center = cell_edge_size / 2
var next_move
var selected_card
var selected_creatures = []
var cells = []
var score = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_value_label.text = str(score)
	for i in range(0, 49):
		var cell = cell_scene.instantiate()
		cell.row = i / 7
		cell.column = i % 7
		var new_sb = StyleBoxFlat.new()
		new_sb.bg_color = Color("a58dff")
		cell.add_theme_stylebox_override("normal", new_sb)
		cell.custom_minimum_size = Vector2(cell_edge_size, cell_edge_size)	
		cell.connect("button_up", _on_cell_button_up.bind(cell))
		grid.add_child(cell)
		cells.push_back(cell)
		var creature = _get_random_creature_maybe()
		if creature != null:
			creature.size = cell.custom_minimum_size * 0.8
			creature.position = Vector2(cell_edge_center, cell_edge_center)
			creature.row = cell.row
			creature.column = cell.column
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
	
func _get_random_card():
	var rand = rng.randi_range(0, 3)
	var rule
	var score
	if rand == 0:
		rule = Enums.CARD_RULE_TYPE.FOUR_IN_A_ROW
		score = 10
	elif rand == 1:
		rule = Enums.CARD_RULE_TYPE.FIVE_IN_A_ROW
		score = 20
	elif rand == 2:
		rule = Enums.CARD_RULE_TYPE.SQUARE
		score = 20
	elif rand == 3:
		rule = Enums.CARD_RULE_TYPE.TWO_BY_THREE
		score = 50
		
	var card = card_scene.instantiate()
	card.init(score, rule)
	
	return card

func _get_random_next_move():
	var rand = rng.randi_range(0, 4)
	
	if rand < 4:
		print("creature")
		var result = move.new(Enums.MOVE_TYPE.CREATURE)
		result.creature = _get_random_creature()
		return result
	else:
		print("card")
		var result = move.new(Enums.MOVE_TYPE.CARD)
		result.card = _get_random_card()
		return result
		
		
func _display_next_move():
	for n in next_move_placeholder.get_children():
		next_move_placeholder.remove_child(n)
		n.queue_free()
	
	var placeholder_center = Vector2(next_move_placeholder.size.x / 2, next_move_placeholder.size.y / 2)
	if next_move.move_type == Enums.MOVE_TYPE.CREATURE:
		next_move.creature.size = next_move_placeholder.size * 0.8
		next_move.creature.position = placeholder_center
		next_move_placeholder.add_child(next_move.creature)
	elif next_move.move_type == Enums.MOVE_TYPE.CARD:
		next_move.card.size = next_move_placeholder.size * 0.8
		next_move.card.position = placeholder_center
		next_move_placeholder.add_child(next_move.card)
		next_move.card.card_bgr.connect("gui_input", _on_card_gui_input.bind(next_move.card))
		
func _on_cell_button_up(cell: Button):
	if selected_card != null:
		if cell.get_child_count() > 0:
			var creature = cell.get_child(0)
			if creature.check.visible == false:
				creature.check.visible = true
				selected_creatures.push_back(creature)

			elif creature.check.visible == true:
				creature.check.visible = false
				var index = selected_creatures.find(creature)
				selected_creatures.remove_at(index)
				
			var rule_satisfied = _is_rule_satisfied()
			submit_button.disabled = !rule_satisfied
		else: 
			print("nothing to select")
		return
	
	if next_move.move_type != Enums.MOVE_TYPE.CREATURE:
		print("ignore click")
		return

	if cell.get_child_count() > 0:
		print("cell occupied")
		return
	
	var tiny_creature = tiny_creature_scene.instantiate()
	tiny_creature.row = cell.row
	tiny_creature.column = cell.column
	tiny_creature.colour = next_move.creature.colour	
	tiny_creature.size = cell.custom_minimum_size * 0.8
	tiny_creature.position = Vector2(cell_edge_center, cell_edge_center)
	cell.add_child(tiny_creature)
	next_move = _get_random_next_move()
	_display_next_move()
	
func _on_card_gui_input(event: InputEvent, card):
	if event is InputEventMouseButton and !event.pressed: # pressed == false means the mouse button's state is released.
		var card_in_hand = card_scene.instantiate()
		card_in_hand.init(card.score, card.rule)
		card_in_hand.size.y = cards_container.size.y
		card_in_hand.size.x = cards_container.size.y * 0.75
		card_in_hand.position.y = cards_container.size.y / 2
		
		var control = Control.new()
		control.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		control.add_child(card_in_hand)
		
		cards_container.add_child(control)
		card_in_hand.index_in_hand = cards_container.get_child_count() - 1
		
		card_in_hand.card_bgr.connect("gui_input", _on_card_in_hand_gui_input.bind(card_in_hand))
		
		next_move = _get_random_next_move()
		_display_next_move()
		
func _on_card_in_hand_gui_input(event: InputEvent, card):
	if event is InputEventMouseButton and !event.pressed: # pressed == false means the mouse button's state is released.
		if card.check.visible == true:
			card.check.visible = false
			selected_card = null
			
			for n in selected_creatures:
				n.check.visible = false
			selected_creatures.clear()
			print(selected_creatures)
			submit_button.disabled = true
			
			return
		
		for n in cards_container.get_children():
			var other_card = n.get_child(0)
			other_card.check.visible = false
		
		card.check.visible = true
		selected_card = card
		
func _is_rule_satisfied():
	if selected_card.rule == Enums.CARD_RULE_TYPE.FOUR_IN_A_ROW:
		return _is_size_satisfied(4) && _is_colour_satisfied() && _is_line()
	
	if selected_card.rule == Enums.CARD_RULE_TYPE.FIVE_IN_A_ROW:
		return _is_size_satisfied(5) && _is_colour_satisfied() && _is_line()
		
	if selected_card.rule == Enums.CARD_RULE_TYPE.SQUARE:
		return _is_size_satisfied(4) && _is_colour_satisfied()
		
	if selected_card.rule == Enums.CARD_RULE_TYPE.TWO_BY_THREE:
		return _is_size_satisfied(6) && _is_colour_satisfied()
		
func _is_size_satisfied(size: int):
	return selected_creatures.size() == size
	
func _is_colour_satisfied():
	return selected_creatures.all(func(x): return x.colour == selected_creatures[0].colour)
	
func _is_line():
	# horizontal
	if selected_creatures.all(func(x): return x.row == selected_creatures[0].row):
		selected_creatures.sort_custom(func(a, b): return a.column < b.column)
		for i in range(1, selected_creatures.size()):
			var diff = selected_creatures[i].column - selected_creatures[i-1].column
			if diff > 1:
				return false
		return true
	# vertical
	if selected_creatures.all(func(x): return x.column == selected_creatures[0].column):
		selected_creatures.sort_custom(func(a, b): return a.row < b.row)
		for i in range(1, selected_creatures.size()):
			var diff = selected_creatures[i].row - selected_creatures[i-1].row
			if diff > 1:
				return false
		return true
	# diagonal

func _on_submit_button_button_up() -> void:
	submit_button.disabled = true
	if !_is_rule_satisfied():
		return
		
	for n in selected_creatures:
		var selected_cell = cells.filter(func(x): return x.row == n.row && x.column == n.column)[0]
		selected_cell.remove_child(n)
		n.queue_free()
	selected_creatures.clear()

	score += selected_card.score
	score_value_label.text = str(score)

	selected_card.check.visible = false
	var to_remove = cards_container.get_child(selected_card.index_in_hand)
	cards_container.remove_child(to_remove)
	to_remove.queue_free()
	selected_card = null
