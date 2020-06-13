extends Control


# Variables to optimize code
onready var OptionsContainer = $OptionsPanel/ScrollContainer/OptionsContainer
onready var ConquestName = $ConquestPanel/NamePanel/ConquestName
onready var ConquestPanel = $ConquestPanel
onready var OptionsPanel = $OptionsPanel

var current_panel  # tracks the curent panel
var conquest_name  # tracks the current conquest name


func _ready():
	current_panel = OptionsPanel
	_get_conquest_buttons()


# Gets the conquest buttons
func _get_conquest_buttons():
	for row_options in OptionsContainer.get_children():
		for button in row_options.get_children():
			button.connect("pressed", self, "_on_Button_pressed", [button.get_node("Label")])


# Method is run when a conquest button has been pressed
func _on_Button_pressed(label):
	var conquest_text = label.text
	var space_index = conquest_text.find("\n")
	conquest_name = conquest_text.substr(space_index + 2, len(conquest_text))
	ConquestName.text = conquest_name
	
	current_panel = ConquestPanel
	ConquestPanel.show()


# Shows the Conquest UI
func _on_Conquest_pressed():
	current_panel = OptionsPanel
	show()


# Hides the current panel
func _on_CloseConquest_pressed():
	match current_panel:
		OptionsPanel:
			hide()
		ConquestPanel:
			ConquestPanel.hide()
			current_panel = OptionsPanel
