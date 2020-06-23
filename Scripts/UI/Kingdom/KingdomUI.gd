extends Control


var current_panel = self

var original_color = Color(1, 1, 1, 1)
var dimmed_color = original_color.darkened(0.5)

onready var misc_buttons = $MiscButtons
onready var options = $OptionsButtons/Options
onready var close_button = $CloseKingdom
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


# Dims the background of the UI
func _dim_background(color):
	
	for node in self.get_children():
		if node != current_panel and node != close_button:
			node.set_modulate(color)


# Shows the Alliance UI
func _on_Kingdom_pressed():
	show()


# Hides the Alliance UI
func _on_CloseKingdom_pressed():
	if current_panel in panels:
		current_panel.hide()
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
				current_panel.hide()
				current_panel = self
				_dim_background(original_color)


# Sets the current panel
func set_current_panel(panel):
	current_panel = panel
