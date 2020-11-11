extends Control


onready var info_panel = $InformationPanel
onready var options = $OptionsContainer

var panels
var current_panel


func _ready():
	panels = info_panel.get_children()
	_get_options()


func _get_options():
	for button in options.get_children():
		button.connect("pressed", self, "_on_Option_pressed", [button.name])


# When an option is pressed
func _on_Option_pressed(name):
	match name:
		"Trade":
			current_panel = panels[0]
		"Tax":
			current_panel = panels[1]
			current_panel.check_tax_building()
		"Manage":
			current_panel = panels[2]
		"Teams":
			current_panel = panels[3]
	
	_show_hide_panels()


# Shows the proper panel when the option is pressed
func _show_hide_panels():
	for index in range(len(panels)):
		if panels[index] == current_panel:
			panels[index].show()
		else:
			panels[index].hide()


# Shows the City UI
func _on_City_pressed():
	current_panel = panels[0]
	_show_hide_panels()
	show()


# Hides the City UI
func _on_CloseCity_pressed():
	hide()
