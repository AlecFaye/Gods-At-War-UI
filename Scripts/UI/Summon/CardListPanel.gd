extends Panel


# Enum to keep track of card attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

var sprite_holder = []
var image_holder = []
var card_slots = []
var labels = []
var scroll_index = []
var starting_index

onready var card_container = $BackgroundPanel/ScrollContainer/CardContainer
onready var card_pack_name = $CardPackName
onready var scroll_container = $BackgroundPanel/ScrollContainer
onready var max_scroll_timer = $MaxScrollTimer
onready var current_scroll_timer = $CurrentScrollTimer


func _ready():
	_get_card_slots()
	_get_rate_labels()


# Gets the card slots for the Cards List Panel
func _get_card_slots():
	var rows = card_container.get_children()
	var buttons = []
	
	for row in rows:
		buttons.append(row.get_children())
	
	for current_button in buttons:
		for sprite in current_button:
			card_slots.append(sprite.get_node("CardSprite"))


# Displays the card list
func display_card_list(card_pack):
	sprite_holder = []
	image_holder = []
	starting_index = 10
	
	# Clears the card list
	for index in range(len(card_slots)):
		var sprite = card_slots[index]
		var image = sprite.get_parent()
		var row = image.get_parent()
		
		sprite.texture = null
		image.hide()
		row.hide()
	
	# Sets the card list up but doesn't load the pictures in yet
	for index in range(len(card_pack)):
		var sprite = card_slots[index]
		var god = card_pack[index]
		var image = sprite.get_parent()
		var row = image.get_parent()
		
		sprite_holder.append(sprite)
		image_holder.append(god[IMAGE])
		
		image.show()
		row.show()
	
	# Loads the first 10 cards
	for index in range(starting_index):
		sprite_holder[index].texture = load(image_holder[index])
	
	var scrollbar = scroll_container.get_v_scrollbar()
	scrollbar.value = scrollbar.min_value
	max_scroll_timer.start()


# Gets the rate labels
func _get_rate_labels():
	var draw_rates_panel = get_node("DrawRatesPanel/RateLabelContainer")
	var rows = draw_rates_panel.get_children()
	labels = []
	
	for row in rows:
		var label = row.get_node("Rate")
		labels.append(label)


# Sets the draw rates
func set_draw_rates(rates):
	for index in range(len(labels)):
		labels[index].text = str(rates[index]) + "%"


# Sets the card pack name
func  set_name(name):
	card_pack_name.text = name


# Get the scroll index
func _on_MaxScrollTimer_timeout():
	var scrollbar = scroll_container.get_v_scrollbar()
	var max_scroll_value = scrollbar.max_value
	
	scroll_index.clear()
	
	for index in range(0, max_scroll_value, 150):
		scroll_index.append(index)
	
	current_scroll_timer.start()


# Get the current scroll
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
		sprite_holder[index].texture = load(image_holder[index])
