extends Control

@onready var score_label = get_node("CanvasLayer/VBoxContainer/ScoreLabel")

var score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	score_label.text = score_label.text % score


func _on_button_button_up() -> void:
	get_tree().paused = false
	
	var game_screen = get_node("/root/GameScreen")
	game_screen.init()
	
	self.get_parent().remove_child(self)
	self.queue_free()
	
