extends Panel


# Enums for the card attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

var card_slots = []

var legend_offset = Vector2(-30, -40)  # Legend card offset
var epic_offset = Vector2(-15, -20)    # Epic card offset

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


onready var CardsUI = $".."
onready var sort_panel = $"../SortPanel"
onready var card_container = $ScrollContainer/VerticalAlignment
onready var scroll_container = $ScrollContainer


func _ready():
	_get_card_slots()


# Gets all the possible slots in the card holder
func _get_card_slots():
	
	# Gets the container rows
	var row_containers = card_container.get_children()
	var buttons = []
	
	# Gets the buttons in each container row
	for row in row_containers:
		if row is HBoxContainer:
			buttons.append(row.get_children())
	
	# Gets the card sprites in each button
	for current_button in buttons:
		for sprite in current_button:
			card_slots.append(sprite.get_node("CardSprite"))


# Fills the cards by the sort attribute
func fill_card_slots(sort_attribute):
	
	var player_cards = CardsUI.get_player_cards()
	_clear_card_slots()
	
	var scrollbar = scroll_container.get_v_scrollbar()
	scroll_container.scroll_vertical = scrollbar.min_value
	
	match sort_attribute:
		"name":
			player_cards.sort_custom(self, "_name_comparison")
			for index in range(len(player_cards)):
				var sprite = card_slots[index]
				var god = player_cards[index]
				var rarity = god[RARITY]
				
				_set_sprite_offset(sprite, rarity)
				
				sprite.texture = load(god[IMAGE])
				sprite.get_parent().show()
		"rarity":
			_organize_cards(rarity_sort)
		"region":
			_organize_cards(region_sort)
		"type":
			_organize_cards(type_sort)


# Resets the card slots and removes labels
func _clear_card_slots():
	
	# Clears the card slots and hides them
	for index in range(len(card_slots)):
		var sprite = card_slots[index]
		sprite.texture = null
		sprite.get_parent().hide()
	
	# Removes the labels
	var row_containers = card_container.get_children()
	for row in row_containers:
		if row is Label:
			card_container.remove_child(row)


# Sorts the cards and labels
func _organize_cards(attribute_dic):
	var label_index = 0  # Keeps track of the label index
	var card_index = 0   # Keeps track of the card index
	var label_count = 0  # Keeps track of the number of labels
	
	var card_groups = sort_panel.get_card_groups()
	
	# Runs through the attribute in order
	for attribute in range(len(attribute_dic)):
		var gods = card_groups[attribute_dic[attribute]]
		
		# If there is more than one god, this condition is true
		if len(gods) > 0:
			_insert_label(label_index, attribute_dic[attribute])
			label_count += 1
			
			# Sets the image of the god to the card slot and show it
			for index in range(len(gods)):
				var sprite = card_slots[index + card_index]
				var god = gods[index]
				var rarity = god[RARITY]
				
				_set_sprite_offset(sprite, rarity)
				
				sprite.texture = load(god[IMAGE])
				sprite.get_parent().show()
			
			# Calculates the next label index and card index
			label_index = label_index + ceil(len(gods) / 5.0) + 1
			card_index = (label_index - label_count) * 5


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
	card_container.add_child(label)
	card_container.move_child(label, index)


# Sets the offset for the card
func _set_sprite_offset(sprite, rarity):
	if rarity == "Legend":
		sprite.set_offset(legend_offset)
	elif rarity == "Epic":
		sprite.set_offset(epic_offset)
	else:
		sprite.set_offset(Vector2(0, 0))


# Name comparator for the player cards
func _name_comparison(a, b):
	return a[NAME] < b[NAME]


# Returns the rarity sort array
func get_rarity_sort():
	return rarity_sort
