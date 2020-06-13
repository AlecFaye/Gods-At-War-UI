extends Panel


var original_position = Vector2(0, 0)
var target_position = Vector2(0, 42)


# Animates the fame panel
func _on_Fame_toggled(button_pressed):
	
	var FamePanel = $"../BottomPanel/Fame/FameCountPanel"
	
	if button_pressed:
		FamePanel.move(Vector2(0, -40))
	else:
		FamePanel.move(original_position)


# Animates the territory panel
func _on_Territory_toggled(button_pressed):
	
	var TerritoryPanel = $Territory/TerritoryCountPanel
	
	if button_pressed:
		TerritoryPanel.move(target_position)
	else:
		TerritoryPanel.move(original_position)


# Animates the server time panel
func _on_ServerTime_toggled(button_pressed):
	
	var ServerTimePanel = $ServerTime/ServerTimePanel
	
	if button_pressed:
		ServerTimePanel.move(target_position)
	else:
		ServerTimePanel.move(original_position)


# Animates the local time panel
func _on_LocalTime_toggled(button_pressed):
	
	var LocalTimePanel = $LocalTime/LocalTimePanel
	
	if button_pressed:
		LocalTimePanel.move(target_position)
	else:
		LocalTimePanel.move(original_position)
