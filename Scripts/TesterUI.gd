extends Control


func load_panel_position():
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	
	var label = $WindowSizePanel/HBoxContainer/Size
	label.text = "(" + str(width) + ", " + str(height) + ")"
	
	var panel2 = $"../SkillsUI/SkillInfo2DNode/SkillInfoPanel"
	var label2 = $WindowSizePanel/HBoxContainer2/Size
	label2.text = "(" + str(panel2.rect_position.x) + ", " + str(panel2.rect_position.y) + ")"
