extends Control


onready var PlayerOptions = $BasicPanel/BasicInfoContainer/BottomPanelContainer/ChoicePanel/PlayerOptions

onready var ResourcePanel = $BasicPanel/BasicInfoContainer/BottomPanelContainer/InfoPanel/ResourcePanel
onready var BuildingsPanel = $BasicPanel/BasicInfoContainer/BottomPanelContainer/InfoPanel/BuildingsPanel
onready var GairoPanel = $BasicPanel/BasicInfoContainer/BottomPanelContainer/InfoPanel/GairoPanel


func _ready():
	_get_options()


# Gets the options in the basic panel
func _get_options():
	for option in PlayerOptions.get_children():
		option.connect("pressed", self, "_on_Option_pressed", [option.name])


# When an option is pressed
func _on_Option_pressed(name):
	match name:
		"Resource":
			ResourcePanel.show()
			BuildingsPanel.hide()
			GairoPanel.hide()
		"Buildings":
			ResourcePanel.hide()
			BuildingsPanel.show()
			GairoPanel.hide()
		"Gairo":
			ResourcePanel.hide()
			BuildingsPanel.hide()
			GairoPanel.show()


# Shows the Stats UI
func _on_Stats_pressed():
	show()


# Hides the Stats UI
func _on_CloseStats_pressed():
	hide()
