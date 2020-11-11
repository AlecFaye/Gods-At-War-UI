extends Control

# If the extra tabs button is toggled
func _on_ExtraTabsButton_toggled(button_pressed):
	
	var position = Vector2(0, -90)
	
	var ThirdRowNode = get_node("ThirdRow")
	var original_target = Vector2(ThirdRowNode.rect_position)
	
	var FirstRowNode = get_node("FirstRow")
	var first_row_target = Vector2(original_target + position * 2)
	
	var SecondRowNode = get_node("SecondRow")
	var second_row_target = Vector2(original_target + position)
	
	var ExtraTabsButton = $ExtraTabsButton
	
	if button_pressed:
		FirstRowNode.move(first_row_target)
		SecondRowNode.move(second_row_target)
		
		ExtraTabsButton.rect_rotation = 180
	else:
		FirstRowNode.move(original_target)
		SecondRowNode.move(original_target)
		
		ExtraTabsButton.rect_rotation = 0
