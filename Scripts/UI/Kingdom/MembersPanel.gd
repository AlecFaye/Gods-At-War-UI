extends Panel


onready var popup = $VBoxContainer/OptionsContainer/FilterButton/Filter
onready var options_container = $VBoxContainer/OptionsContainer


func _ready():
	_get_options_buttons()
	_set_up_popup()


# Gets the option's buttons
func _get_options_buttons():
	for option in options_container.get_children():
		option.connect("pressed", self, "_on_Option_pressed", [option.name])


# When an option is pressed
func _on_Option_pressed(name):
	match name:
		"Member":
			pass
		"Group":
			pass
		"Applications":
			pass
		"Invite":
			pass
		"PlayerInfo":
			pass
		"FilterButton":
			popup.show()


# Sets up the popup menu
func _set_up_popup():
	popup.clear()
	
	popup.add_item("Default", 1)
	popup.add_item("Contribution", 2)
	popup.add_item("Influence", 3)
	popup.add_item("Honor", 4)
	
	popup.set_position(popup.get_parent().rect_position + Vector2(50, 170))
	
	popup.connect("id_pressed", self, "_popupMenuChoice")


# If a choice is chosen on the popup menu
func _popupMenuChoice(ID):
	
	var sort_attribute
	
	match ID:
		1:
			sort_attribute = "Default"
		2:
			sort_attribute = "Contribution"
		3:
			sort_attribute = "Influence"
		4:
			sort_attribute = "Honor"
	
	popup.get_parent().text = sort_attribute
