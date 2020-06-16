extends Control


onready var MiscButtons = $MiscButtons
onready var Options = $OptionsButtons/Options

var current_panel = self
var panels


func _ready():
	for button in MiscButtons.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])
	
	for button in Options.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])
	
	panels = [$CalendarPanel, $LogsPanel, $ReportsPanel,
	$MembersPanel, $InfluencePanel, $DiplomacyPanel, $LegionPanel]


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


# Shows the corresponding panel
func _show_panel():
	for index in range(len(panels)):
		if panels[index] == current_panel:
			panels[index].show()
		else:
			panels[index].hide()


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


# When the mouse presses outside a panel
func _input(event):
	
	var x1 = current_panel.rect_position.x
	var x2 = current_panel.rect_size.x + x1
	var y1 = current_panel.rect_position.y
	var y2 = current_panel.rect_size.y + y1
	
	if current_panel in panels:
		if event is InputEventMouseButton:
			if event.position.x < x1 or event.position.x > x2 or \
					event.position.y < y1 or event.position.y > y2:
				current_panel.hide()
				current_panel = self


# Sets the current panel
func set_current_panel(panel):
	current_panel = panel

