extends Control


var current_panel = self
var enable_button = true

var original_color = Color(1, 1, 1, 1)
var dimmed_color = original_color.darkened(0.5)

onready var kingdom_info_panel = $KingdomInfoPanel
onready var no_kingdom_panel = $NoKingdomPanel

onready var misc_buttons = $MiscButtons
onready var options = $OptionsButtons/Options
onready var close_button = $CloseKingdom

onready var buttons_timer = $ButtonsTimer

onready var panels = [
	$CalendarPanel, 
	$LogsPanel, 
	$ReportsPanel,
	$MembersPanel, 
	$InfluencePanel, 
	$DiplomacyPanel, 
	$LegionPanel,
	]


func _ready():
	_get_buttons()


# Checks if the player is in a kingdom
func _is_player_in_kingdom():
	if no_kingdom_panel.is_in_kingdom():
		kingdom_info_panel.hide()
	else:
		kingdom_info_panel.show()


# Gets the buttons
func _get_buttons():
	for button in misc_buttons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])
	
	for button in options.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])


# When an option is pressed
func _on_Button_pressed(name):
	match name:
		"Calendar":
			current_panel = panels[0]
		"Logs":
			current_panel = panels[1]
		"Reports":
			current_panel = panels[2]
		"Members":
			current_panel = panels[3]
		"Influence":
			current_panel = panels[4]
		"Diplomacy":
			current_panel = panels[5]
		"Legion":
			current_panel = panels[6]
	
	_show_panel()
	_dim_background(dimmed_color)


# Shows the corresponding panel
func _show_panel():
	for index in range(len(panels)):
		if panels[index] == current_panel:
			panels[index].show()
		else:
			panels[index].hide()
	
	kingdom_info_panel.hide()


# Dims the background of the UI
func _dim_background(color):
	
	for node in self.get_children():
		if node != current_panel and node != close_button and node != buttons_timer:
			node.set_modulate(color)
	
	if color == original_color:
		enable_button = false
	else:
		enable_button = true
	
	buttons_timer.start()


# Shows the Alliance UI
func _on_Kingdom_pressed():
	show()
	_is_player_in_kingdom()


# Hides the Alliance UI
func _on_CloseKingdom_pressed():
	if current_panel in panels:
		current_panel.hide()
		kingdom_info_panel.show()
		current_panel = self
	else:
		hide()
	_dim_background(original_color)


# When the mouse presses outside a panel
func _input(event):
	
	var x1 = current_panel.rect_position.x
	var x2 = current_panel.rect_size.x + x1
	var y1 = current_panel.rect_position.y
	var y2 = current_panel.rect_size.y + y1
	
	var x3 = close_button.rect_position.x
	var x4 = close_button.rect_size.x + x3
	var y3 = close_button.rect_position.y
	var y4 = close_button.rect_size.y + y3
	
	if current_panel in panels:
		if event is InputEventMouseButton:
			if (event.position.x < x1 or event.position.x > x2 or \
					event.position.y < y1 or event.position.y > y2) and \
					(event.position.x < x3 or event.position.x > x4 or \
					event.position.y < y3 or event.position.y > y4):
				close_button.emit_signal("pressed")


# Sets the current panel
func set_current_panel(panel):
	current_panel = panel


# Enables and disables buttons
func _on_ButtonsTimer_timeout():
	for node in misc_buttons.get_children():
		node.disabled = enable_button
	
	for node in options.get_children():
		node.disabled = enable_button
	
	var edit_button = $NoticePanel/VBoxContainer/HBoxContainer/Edit
	edit_button.disabled = enable_button
