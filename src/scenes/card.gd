extends Node2D

@onready var card_bgr = get_node("CardBackground")
@onready var rule_label = get_node("CardBackground/RuleArea/Label")
@onready var score_label = get_node("CardBackground/ScoreArea/Label")

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
		card_bgr.size = size
	

func init(score: int, rule: Enums.CARD_RULE_TYPE):
	self.score = score
	self.rule = rule
