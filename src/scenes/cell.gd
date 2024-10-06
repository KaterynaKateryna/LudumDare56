extends Button

var row
var column

func _on_cell_rect_changed():
	if self.size.x != 0 && self.size.y != 0 && self.get_child_count() > 0:
		var creature = self.get_children()[0]
		creature.size = self.size * 0.8
		creature.position = self.size / 2
