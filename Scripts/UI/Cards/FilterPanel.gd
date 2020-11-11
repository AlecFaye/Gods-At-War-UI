extends Panel


var popups = []

var rarity = "Rarity (None)"
var region = "Region (None)"
var type = "Type (None)"

onready var sacrifice_panel = $".."
onready var rarity_popup = $FilterContainer/Rarity/PopupMenu
onready var region_popup = $FilterContainer/Region/PopupMenu
onready var type_popup = $FilterContainer/Type/PopupMenu
onready var filter_container = $FilterContainer


func _ready():
	popups = [rarity_popup, region_popup, type_popup]
	_get_filter_buttons()
	_set_up_popups()


# Gets the filter buttons
func _get_filter_buttons():
	for filter in filter_container.get_children():
		filter.connect("pressed", self, "_on_Filter_pressed", [filter.name])


# When a fitler button is pressed
func _on_Filter_pressed(name):
	var current_popup
	
	match name:
		"Rarity":
			current_popup = rarity_popup
		"Region":
			current_popup = region_popup
		"Type":
			current_popup = type_popup
	
	_display_popup(current_popup)


# Shows and hides other popup menus
func _display_popup(popup):
	hide_popups()
	
	for index in range(len(popups)):
		if popups[index] == popup:
			popups[index].show()


# Sets up the popup menus
func _set_up_popups():
	var offset = Vector2(175, 175)
	
	for popup in popups:
		popup.clear()
	
	rarity_popup.add_item("None", 1)
	rarity_popup.add_item("Legend", 2)
	rarity_popup.add_item("Epic", 3)
	rarity_popup.add_item("Rare", 4)
	rarity_popup.add_item("Uncommon", 5)
	rarity_popup.add_item("Common", 6)
	
	region_popup.add_item("None", 7)
	region_popup.add_item("Hindu", 8)
	region_popup.add_item("Japanese", 9)
	region_popup.add_item("Chinese", 10)
	region_popup.add_item("Roman", 11)
	region_popup.add_item("Nordic", 12)
	region_popup.add_item("Egyptian", 13)
	region_popup.add_item("American", 14)
	
	type_popup.add_item("None", 15)
	type_popup.add_item("Death", 16)
	type_popup.add_item("Life", 17)
	type_popup.add_item("Wood", 18)
	type_popup.add_item("Fire", 19)
	type_popup.add_item("Earth", 20)
	type_popup.add_item("Metal", 21)
	type_popup.add_item("Water", 22)
	
	for popup in popups:
		popup.set_position(filter_container.rect_position + offset)
		popup.connect("id_pressed", self, "_popupMenuChoice")


# If a choice was chosen in the popup menu, set the sort_attribute to that
func _popupMenuChoice(ID):
	var sort_attribute
	var button
	
	match ID:
		1:
			sort_attribute = "Rarity (None)"
		2:
			sort_attribute = "Legend"
		3:
			sort_attribute = "Epic"
		4:
			sort_attribute = "Rare"
		5:
			sort_attribute = "Uncommon"
		6:
			sort_attribute = "Common"
		7:
			sort_attribute = "Region (None)"
		8:
			sort_attribute = "Hindu"
		9:
			sort_attribute = "Japanese"
		10:
			sort_attribute = "Chinese"
		11:
			sort_attribute = "Roman"
		12:
			sort_attribute = "Nordic"
		13:
			sort_attribute = "Egyptian"
		14:
			sort_attribute = "American"
		15:
			sort_attribute = "Type (None)"
		16:
			sort_attribute = "Death"
		17:
			sort_attribute = "Life"
		18:
			sort_attribute = "Wood"
		19:
			sort_attribute = "Fire"
		20:
			sort_attribute = "Earth"
		21:
			sort_attribute = "Metal"
		22:
			sort_attribute = "Water"
	
	if ID < 7:
		button = rarity_popup.get_parent()
		rarity = sort_attribute
	elif ID < 15:
		button = region_popup.get_parent()
		region = sort_attribute
	elif ID < 23:
		button = type_popup.get_parent()
		type = sort_attribute
	
	button.text = sort_attribute
	
	sacrifice_panel.get_card_groups()
	sacrifice_panel.set_filters(rarity, region, type)


# Hides the popups
func hide_popups():
	for popup in popups:
		popup.hide()


# When you click outside the box
#func _input(event):
#
#	var x1 = self.rect_position.x + self.rect_size.x
#	var x2 = x1 + 125
#	var y1 = self.rect_position.y + self.rect_size.y
#	var y2 = y1 + 75
#
#	if event is InputEventMouseButton:
#		if event.position.x < x1 or event.position.x > x2 or \
#				event.position.y < y1 or event.position.y > y2:
#			hide_popups()


# Gets the popups
func get_popups():
	return popups


# Animates movement for the sort panel
func move(target):
	var FilterTween = get_node("FilterTween")
	FilterTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	FilterTween.start()
