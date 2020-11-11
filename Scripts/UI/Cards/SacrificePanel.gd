extends Panel


# Enums for the card attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

var card_groups
var sprite_holder = []
var card_slots = []
var cards = []
var rarity_sort = ["Legend", "Epic", "Rare", "Uncommon", "Common"]

var _rarity = "Rarity (None)"
var _region = "Region (None)"
var _type = "Type (None)"

var scroll_index = []
var starting_index = 5
var procedural_loading

var original_position = Vector2(35, 600)
var target_position = Vector2(35, 60)

onready var sort_panel = $"../SortPanel"
onready var cards_to_sacrifice_panel = $CardsToSacrificePanel

onready var row_container = $Cards/CardsBackground/ScrollContainer/RowContainer
onready var scroll_container = $Cards/CardsBackground/ScrollContainer
onready var max_scroll_timer = $MaxScrollTimer
onready var current_scroll_timer = $CurrentScrollTimer
onready var toggle_sacrifice_button = $CardsToSacrificePanel/CardsToSacrifice


func _ready():
	_get_card_slots()


# Gets the available card slots
func _get_card_slots():
	
	var rows = row_container.get_children()
	var images = []
	
	for row in rows:
		images.append(row.get_children())
	
	for image in images:
		for sprite in image:
			card_slots.append(sprite.get_node("CardSprite"))


# Sets the filters for the sacrifice panel
func set_filters(rarity, region, type):
	_rarity = rarity
	_region = region
	_type = type
	
	set_up_display_cards()


# Displays the sacrifice cards
func set_up_display_cards():
	var rarity_check = true
	var region_check = true
	var type_check = true
	procedural_loading = false
	
	cards.clear()
	sprite_holder.clear()
	
	for index in range(len(card_slots)):
		var sprite = card_slots[index]
		var image = sprite.get_parent()
		var row = image.get_parent()
		
		sprite.texture = null
		image.hide()
		row.hide()
	
	for rarity in rarity_sort:
		var rarity_cards = card_groups[rarity]
		
		for god in rarity_cards:
			cards.append(god)
	
	if _rarity == "Rarity (None)":
		rarity_check = false
	if _region == "Region (None)":
		region_check = false
	if _type == "Type (None)":
		type_check = false
	
	if rarity_check:
		_remove_cards(_rarity, RARITY)
	if region_check:
		_remove_cards(_region, REGION)
	if type_check:
		_remove_cards(_type, TYPE)
	
	if len(cards) > starting_index:
		procedural_loading = true
	
	for index in range(len(cards)):
		var god = cards[index]
		var sprite = card_slots[index]
		var image = sprite.get_parent()
		var row = image.get_parent()
		
		image.show()
		row.show()
		
		sprite_holder.append(god[IMAGE])
	
	if procedural_loading:
		max_scroll_timer.start()
		for index in range(starting_index):
			card_slots[index].texture = load(sprite_holder[index])
	else:
		for index in range(len(cards)):
			card_slots[index].texture = load(sprite_holder[index])


# Removes cards if the attributes do not match
func _remove_cards(attribute, ATTRIBUTE_INDEX):
	var removed_count = 0
	
	for index in range(len(cards)):
		var god = cards[index - removed_count]
		
		if god[ATTRIBUTE_INDEX] != attribute:
			cards.remove(index - removed_count)
			removed_count = removed_count + 1


# Gets the card groups after they have been sorted
func get_card_groups():
	card_groups = sort_panel.get_card_groups()


# Gets the max scroll value
func _on_MaxScrollTimer_timeout():
	var scrollbar = scroll_container.get_v_scrollbar()
	var max_scroll = scrollbar.max_value
	scroll_index.clear()
	
	for index in range(0, max_scroll, 150):
		scroll_index.append(index)
	
	starting_index = 5
	current_scroll_timer.start()


# Gets the current scroll value
func _on_CurrentScrollTimer_timeout():
	var scrollbar = scroll_container.get_v_scrollbar()
	var current_scroll = scrollbar.value
	
	if current_scroll >= scroll_index[0]:
		_load_cards(starting_index)
		scroll_index.remove(0)
		
		if starting_index == len(sprite_holder) - 5:
			current_scroll_timer.stop()
		
		if starting_index + 5 < len(sprite_holder) - 5:
			starting_index = starting_index + 5
		else:
			starting_index = len(sprite_holder) - 5


# Loads the cards with procedural loading
func _load_cards(start):
	for index in range(start, start + 5):
		card_slots[index].texture = load(sprite_holder[index])


# When the cards to sacrifice panel is toggled
func _on_CardsToSacrifice_toggled(button_pressed):
	if button_pressed:
		cards_to_sacrifice_panel.move(target_position)
		toggle_sacrifice_button.text = "v"
	else:
		cards_to_sacrifice_panel.move(original_position)
		toggle_sacrifice_button.text = "^"
