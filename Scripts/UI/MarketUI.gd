extends Control


onready var OptionsContainer = $OptionsContainer
onready var BlackMarketPanel = $BlackMarketPanel
onready var StorePanel = $StorePanel

var current_panel = OptionsContainer


func _ready():
	_get_store_options()


# Gets and connects the buttons
func _get_store_options():
	for button in OptionsContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])


# If the button is pressed, the corresponding panel will show
func _on_Button_pressed(name):
	match name:
		"BlackMarket":
			BlackMarketPanel.show()
			current_panel = BlackMarketPanel
		"Store":
			StorePanel.show()
			current_panel = StorePanel


# When the Gems are pressed
func _on_Gems_pressed():
	current_panel = StorePanel
	show()
	current_panel.show()


# Shows the Market UI
func _on_Market_pressed():
	show()


# Hides the Market UI
func _on_CloseMarket_pressed():
	match current_panel:
		OptionsContainer:
			hide()
		BlackMarketPanel:
			current_panel.hide()
			current_panel = OptionsContainer
		StorePanel:
			current_panel.hide()
			current_panel = OptionsContainer


