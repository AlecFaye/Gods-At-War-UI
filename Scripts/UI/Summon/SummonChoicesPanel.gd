extends Panel


# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

# Enum fror the card's attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

# Random Number Generator
var rng = RandomNumberGenerator.new()

onready var CardsUI = $"../../../CardsUI"
onready var SummonUI = $"../.."

onready var drawn_cards_panel = $"../DrawnCardsPanel"
onready var summon_panel = $".."
onready var error_message_panel = $"../../ErrorMessagePanel"


# Summons from the pack once
func _on_1xSummon_pressed():
	# Checks if they can summon 1 card
	if CardsUI.can_summon(1):
		SummonUI.set_current_panel(DRAWN_CARDS)
		_draw_cards(1)
	else:
		error_message_panel.show()
		error_message_panel.get_node("ErrorMessageTimer").start()


# Summons from the pack five times
func _on_5xSummon_pressed():
	# Checks if they can summon 5 cards
	if CardsUI.can_summon(5):
		SummonUI.set_current_panel(DRAWN_CARDS)
		_draw_cards(5)
	else:
		error_message_panel.show()
		error_message_panel.get_node("ErrorMessageTimer").start()


# Draws cards based on the number of attempts
func _draw_cards(attempts):
	var random_draw = 0
	var drawn_cards = []
	
# warning-ignore:unused_variable
	for count in range(attempts):
		rng.randomize()
		random_draw = rng.randi() % 10000
		
		# Determines the rarity of the card
		var rarity_type = _choose_rarity_type(random_draw)
		
		# Adds the card to drawn cards array
		drawn_cards.append(_summon_card(rarity_type))
	
	# Displays the drawn cards
	drawn_cards_panel.display_drawn_cards(drawn_cards)


# Chooses the rarity and type of card
func _choose_rarity_type(random_draw):
	
	var rate_chart = summon_panel.get_rate_chart()
	var named_rates = summon_panel.get_named_rates()
	
	# For loops through the rate chart array
	for index in range(len(rate_chart) - 1):
		# Gets the left limit and the right limit
		var left_limit = rate_chart[index]
		var right_limit = rate_chart[index + 1]
		
		# Checks if the left limit is not equal to the right limit
		if left_limit != right_limit:
			
			# Checks if the draw was between the two limits and returns the rarity
			if left_limit <= random_draw and random_draw < right_limit:
				return named_rates[index]


# Summons a card based on the rarity and type
func _summon_card(rarity_type):
	
	# Array to hold the possible gods that can be drawn
	var choose_gods = []
	
	var rarity
	var type
	
	match rarity_type:
		"death_legend_rate":
			rarity = "Legend"
			type = "Death"
		"life_legend_rate":
			rarity = "Legend"
			type = "Life"
		"five_element_legend_rate":
			rarity = "Legend"
			type = "Five Element"
		"death_epic_rate":
			rarity = "Epic"
			type = "Death"
		"life_epic_rate":
			rarity = "Epic"
			type = "Life"
		"five_element_epic_rate":
			rarity = "Epic"
			type = "Five Element"
		"rare_rate":
			rarity = "Rare"
			type = "Five Element"
		"uncommon_rate":
			rarity = "Uncommon"
			type = "Five Element"
		"common_rate":
			rarity = "Common"
			type = "Five Element"
	
	# Gets the card pack to be drawn from
	var card_pack = summon_panel.get_current_card_pack().get_card_pack()
	
	# Fills choose gods array with gods that match the rarity and type
	for god in card_pack:
		if type == "Five Element":
			if god[RARITY] == rarity:
				if god[TYPE] != "Death" and god[TYPE] != "Life":
					choose_gods.append(god)
		else:
			if god[RARITY] == rarity:
				if god[TYPE] == type:
					choose_gods.append(god)
	
	# Randomly choose from the appropriate gods selection
	rng.randomize()
	var card = choose_gods[rng.randi() % len(choose_gods)]
	CardsUI.add_card(card)
	
	return card


# Hides the error message
func _on_ErrorMessageTimer_timeout():
	error_message_panel.hide()
