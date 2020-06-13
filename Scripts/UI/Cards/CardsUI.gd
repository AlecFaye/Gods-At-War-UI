extends Control


# Variables to optimize code
onready var CardContainer = $CardPanel/ScrollContainer/VerticalAlignment
onready var scroll_container = $CardPanel/ScrollContainer
onready var sort_button = $SortButton
onready var sort_panel = $SortPanel

var player_cards = []  # Array to hold the player cards
var card_slots = []    # Array to hold the card slots
var card_limit = 100   # Card slot limit

# Dictionary for the card's array attributes
var card_attribute = {
	"name": 0,
	"rarity": 1,
	"region": 2,
	"type": 3,
	"image": 4
	}

# Dictionary to keep rarity sorted when sorting by region or type
var rarity_dic = {
	"Legend": 0,
	"Epic": 1,
	"Rare": 2,
	"Uncommon": 3,
	"Common": 4
	}

# Array to keep rarity sorted
var rarity_sort = [
	"Legend",
	"Epic",
	"Rare",
	"Uncommon",
	"Common"
	]

# Array to keep region sorted
var region_sort = [
	"Hindu",
	"Japanese",
	"Chinese",
	"Roman",
	"Nordic",
	"Egyptian",
	"American"
	]

# Array to keep type sorted
var type_sort = [
	"Death",
	"Life",
	"Wood",
	"Fire",
	"Earth",
	"Metal",
	"Water"
	]

# Dictionary to group the cards by rarity, region, and type
var card_groups = {
	"Legend": [],
	"Epic": [],
	"Rare": [],
	"Uncommon": [],
	"Common": [],
	"Hindu": [],
	"Japanese": [],
	"Chinese": [],
	"Roman": [],
	"Nordic": [],
	"Egyptian": [],
	"American": [],
	"Death": [],
	"Life": [],
	"Wood": [],
	"Fire": [],
	"Earth": [],
	"Metal": [],
	"Water": []
}

var sort_attribute = "name"


func _ready():
	_get_card_slots()
	_get_sort_buttons()


# Gets all the possible slots in the card holder
func _get_card_slots():
	
	# Gets the container rows
	var row_containers = CardContainer.get_children()
	var buttons = []
	
	# Gets the buttons in each container row
	for row in row_containers:
		if row is HBoxContainer:
			buttons.append(row.get_children())
	
	# Gets the card sprites in each button
	for current_button in buttons:
		for sprite in current_button:
			card_slots.append(sprite.get_node("CardSprite"))


# Gets the buttons in the sort panel
func _get_sort_buttons():
	for button_selection in $SortPanel/ChoiceContainer.get_children():
		button_selection.connect("pressed", self, "_on_SortButton_pressed", [button_selection.text])


# Fills the cards by the sort attribute
func _fill_card_slots():
	
	_clear_card_slots()
	
	match sort_attribute:
		"name":
			player_cards.sort_custom(self, "_name_comparison")
			for index in range(len(player_cards)):
				card_slots[index].texture = load(player_cards[index][4])
				card_slots[index].get_parent().show()
		"rarity":
			_sort_card_slots(rarity_sort)
		"region":
			_sort_card_slots(region_sort)
		"type":
			_sort_card_slots(type_sort)


# Resets the card slots and removes labels
func _clear_card_slots():
	
	# Clears the card slots and hides them
	for index in range(len(card_slots)):
		card_slots[index].texture = null
		card_slots[index].get_parent().hide()
	
	# Removes the labels
	var row_containers = CardContainer.get_children()
	for row in row_containers:
		if row is Label:
			CardContainer.remove_child(row)


# Inserts the label at the index
func _insert_label(index, attribute):
	
	# Creates a label based on the attribute
	var label = Label.new()
	label.text = attribute
	
	# Sets the font to the label
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://Fonts/MorrisRomanBlack.ttf")
	dynamic_font.size = 28
	label.set("custom_fonts/font", dynamic_font)
	
	# Adds the label as a child and moves it to the correct index
	CardContainer.add_child(label)
	CardContainer.move_child(label, index)


# Sorts the cards and labels
func _sort_card_slots(attribute_dic):
	var label_index = 0  # Keeps track of the label index
	var card_index = 0   # Keeps track of the card index
	var label_count = 0  # Keeps track of the number of labels
	
	# Runs through the attribute in order
	for attribute in range(len(attribute_dic)):
		var gods = card_groups[attribute_dic[attribute]]
		
		# If there is more than one god, this condition is true
		if len(gods) > 0:
			_insert_label(label_index, attribute_dic[attribute])
			label_count += 1
			
			# Sets the image of the god to the card slot and show it
			for index in range(len(gods)):
				card_slots[index + card_index].texture = load(gods[index][4])
				card_slots[index + card_index].get_parent().show()
			
			# Calculates the next label index and card index
			label_index = label_index + ceil(len(gods) / 5.0) + 1
			card_index = (label_index - label_count) * 5


# Adds the card to the player cards
func add_card(card):
	player_cards.append(card)


# Checks if the summon is allowed to happen
func can_summon(summon_count):
	if len(player_cards) + summon_count > card_limit:
		return false
	return true


# Determines the sorting attribute
func _on_SortButton_pressed(attribute):
	sort_attribute = attribute.to_lower()
	
	_fill_card_slots()
	
	var scrollbar = scroll_container.get_v_scrollbar()
	scroll_container.scroll_vertical = scrollbar.min_value


# Organize by attribute given
func _sort():
	
	# For loop to go through the attributes
	#	1 = rarity
	#	2 = region
	#	3 = type
	for sort_index in range(1, 4):
		
		# For loop to go through the player's cards
		for card_index in range(len(player_cards)):
			
			# Gets the attribute and appends it to the corresponding card group dictionary
			var attribute = player_cards[card_index][sort_index]
			card_groups[attribute].append(player_cards[card_index])
	
	# If the attribute isnt a rarity, sort them by rarity
	for attribute in card_groups:
		if not attribute in rarity_sort:
			card_groups[attribute].sort_custom(self, "_rarity_comparison")


# Name comparator for the player cards
func _name_comparison(a, b):
	var first = a[0]
	var second = b[0]
	return first < second


# Rarity comparator for the card groups
func _rarity_comparison(a, b):
	var first = a[1]
	var second = b[1]
	return rarity_dic[first] < rarity_dic[second]


# Shows the CardsUI, sorts the cards and fill the card slots
func _on_Cards_pressed():
	_sort()
	_fill_card_slots()
	show()


# Closes the CardsUI
func _on_CloseCards_pressed():
	if sort_button.is_pressed():
		sort_button.set_pressed(false)
	hide()


# Shows the sort options
func _on_SortButton_toggled(button_pressed):
	
	var target_position = Vector2(30, 220)
	var original_position = Vector2(-110, 220)
	
	if button_pressed:
		sort_panel.move(target_position)
		sort_button.text = "<"
	else:
		sort_panel.move(original_position)
		sort_button.text = ">"
