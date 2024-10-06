class_name FontHelper extends Node

static func adjustLabelFont(label: Label, containerSize: Vector2):
	if label == null:
		return
		
	var font = label.get_theme_font("")
	var fontSize = label.get_theme_font_size("")
	
	var textToCheck = label.text

	var minFont = 12 # min font size allowed is 12, just because
	var margin = 8 # a little margin so that words don't look mashed together
	
	var breakFlags = convertAutowrapModeToBreakFlags(label.autowrap_mode)
	
	var txtSize = font.get_multiline_string_size(textToCheck, label.horizontal_alignment, containerSize.x, fontSize, -1, breakFlags, label.justification_flags)
	while ((txtSize.x > containerSize.x - margin) or (txtSize.y > containerSize.y - margin)) and fontSize >= minFont:
		fontSize -= 4
		txtSize = font.get_multiline_string_size(textToCheck, label.horizontal_alignment, containerSize.x, fontSize, -1, breakFlags, label.justification_flags)
	label.set("theme_override_font_sizes/font_size", fontSize)
	
static func adjustButtonFont(button: Button, containerSize: Vector2):
	if button == null:
		return
		
	var font = button.get_theme_font("")
	var fontSize = button.get_theme_font_size("")
	
	var textToCheck = button.text

	var minFont = 12 # min font size allowed is 12, just because
	var margin = 8 # a little margin so that words don't look mashed together
	
	var txtSize = font.get_string_size(textToCheck, button.alignment, containerSize.x, fontSize)
	while ((txtSize.x > containerSize.x - margin) or (txtSize.y > containerSize.y - margin)) and fontSize >= minFont:
		fontSize -= 4
		txtSize = font.get_string_size(textToCheck, button.alignment, containerSize.x, fontSize)
	button.set("theme_override_font_sizes/font_size", fontSize)
	
static func convertAutowrapModeToBreakFlags(autowrap_mode):
	# AutowrapMode to LineBreakFlag mapping is taken from Label implementation:
	# https://github.com/godotengine/godot/blob/c8c483cf57a768110fce57e509f9b855e69d34b7/scene/gui/label.cpp#L147
	
	var break_flags = TextServer.BREAK_MANDATORY
	
	if autowrap_mode == TextServer.AUTOWRAP_WORD_SMART:
		break_flags = TextServer.BREAK_WORD_BOUND ^ TextServer.BREAK_ADAPTIVE ^ TextServer.BREAK_MANDATORY
	if autowrap_mode == TextServer.AUTOWRAP_WORD:
		break_flags = TextServer.BREAK_WORD_BOUND ^ TextServer.BREAK_MANDATORY
	if autowrap_mode == TextServer.AUTOWRAP_ARBITRARY:
		break_flags = TextServer.BREAK_GRAPHEME_BOUND ^ TextServer.BREAK_MANDATORY

	break_flags = break_flags ^ TextServer.BREAK_TRIM_EDGE_SPACES;
	
	return break_flags
