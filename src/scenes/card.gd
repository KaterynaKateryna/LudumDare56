extends Node2D

@onready var card_bgr = get_node("CardBackground")
@onready var rule_area = get_node("CardBackground/RuleArea")
@onready var rule_label = get_node("CardBackground/RuleArea/Label")
@onready var score_area = get_node("CardBackground/ScoreArea")
@onready var score_label = get_node("CardBackground/ScoreArea/Label")
@onready var check = get_node("CardBackground/Check")
@onready var take_button = get_node("CardBackground/Buttons/TakeButton")
@onready var discard_button = get_node("CardBackground/Buttons/DiscardButton")

@export var score: int
@export var rule: Enums.CARD_RULE_TYPE
@export var size: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if rule == Enums.CARD_RULE_TYPE.FOUR_IN_A_ROW:
		rule_label.text = "Four creatures of same colour in a row"
	elif rule == Enums.CARD_RULE_TYPE.FIVE_IN_A_ROW:
		rule_label.text = "Five creatures of same colour in a row"
	elif rule == Enums.CARD_RULE_TYPE.SQUARE:
		rule_label.text = "Four creatures of same colour in a square"
	elif rule == Enums.CARD_RULE_TYPE.TWO_BY_THREE:
		rule_label.text = "Six creatures of same colour 2 by 3"
		
	score_label.text = str(score)
	
	if size != null:
		card_bgr.size.x = size.x 
		card_bgr.size.y = size.y
	

func init(score: int, rule: Enums.CARD_RULE_TYPE):
	self.score = score
	self.rule = rule

func _on_take_button_item_rect_changed() -> void:
	if take_button != null:
		FontHelper.adjustButtonFont(take_button, take_button.size)

func _on_discard_button_item_rect_changed() -> void:
	if discard_button != null:
		FontHelper.adjustButtonFont(discard_button, discard_button.size)

func _on_score_area_item_rect_changed() -> void:
	if score_area != null && score_label != null:
		FontHelper.adjustLabelFont(score_label, score_area.size)

func _on_rule_area_item_rect_changed() -> void:
	if rule_area != null && rule_label != null:
		FontHelper.adjustLabelFont(rule_label, rule_area.size)
