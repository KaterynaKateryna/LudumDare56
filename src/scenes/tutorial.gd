extends Control

func _ready() -> void:
	get_tree().paused = true

func _on_ok_button_button_up() -> void:
	get_tree().paused = false
	
	var game_screen = get_node("/root/GameScreen")
	
	self.get_parent().remove_child(self)
	self.queue_free()
