extends Control


# Appends cards to the list when summoned
onready var CardsUI = $"../CardsUI"

# Variable to find the buttons for the card packs
onready var CardContainer = $SummonPanel/CardScrollContainer/CardContainer

# Variable to find the card display containers
onready var CardDisplayContainer = $SummonPanel/DrawnCardsDisplay/CardsDrawnContainer

# Keeps track of the current panel open
var current_panel

# Variables to show and hide the panels
onready var CardScrollContainer = $SummonPanel/CardScrollContainer
onready var SummonChoicesContainer = $SummonPanel/SummonChoicesPanel
onready var DrawnCardsDisplay = $SummonPanel/DrawnCardsDisplay
onready var CardListPanel = $CardListPanel
onready var ErrorMessagePanel = $ErrorMessagePanel
onready var DrawRatesPanel = $CardListPanel/DrawRatesPanel

# Keeps track of the current card pack chosen
var current_card_pack

# Dictionary for the card's array attributes
var card_attribute = {
	"name": 0,
	"rarity": 1,
	"region": 2,
	"type": 3,
	"image": 4
	}

# Array to keep track the index of the rate's name
var named_rates = [
	"death_legend_rate", 
	"life_legend_rate",
	"five_element_legend_rate",
	"death_epic_rate",
	"life_epic_rate",
	"five_element_epic_rate",
	"rare_rate",
	"uncommon_rate",
	"common_rate"
	]

# Dictionary to keep track of the rates
var rate_dic = {
	"death_legend_rate": 0,
	"life_legend_rate": 0,
	"five_element_legend_rate": 0,
	"death_epic_rate": 0,
	"life_epic_rate": 0,
	"five_element_epic_rate": 0,
	"rare_rate": 0,
	"uncommon_rate": 0,
	"common_rate": 0
	}

# Keeps track of the weights of the rates
var rate_chart

# Random Number Generator
var rng = RandomNumberGenerator.new()

# Array for the particle systems
var particle_systems = []

# Array for the buttons to reveal cards
var reveal_buttons = []


# Finds all the card packs in the card container when loading the game
func _ready():
	current_panel = CardScrollContainer
	_get_drawn_cards_children()
	_get_card_packs_buttons()


# Gets the particle systems for each card
func _get_drawn_cards_children():
	var CardsDrawnContainer = DrawnCardsDisplay.get_node("CardsDrawnContainer")
	var textures = []
	var sprites = []
	
	for texture in CardsDrawnContainer.get_children():
		textures.append(texture)
	
	for node in textures:
		var particle = node.get_node("Particles2D")
		var sprite = node.get_node("CardSprite")
		
		particle_systems.append(particle)
		sprites.append(sprite)
	
	for sprite in sprites:
		var button = sprite.get_node("Reveal")
		reveal_buttons.append(button)
	
	for button in reveal_buttons:
		button.connect("pressed", self, "_on_Reveal_pressed", [button])


# Reveals the card
func _on_Reveal_pressed(button):
	button.hide()


# Gets the card pack buttons
func _get_card_packs_buttons():
	for card_selection in CardContainer.get_children():
		card_selection.connect("pressed", self, "_on_Button_pressed", [card_selection])


# Shows the summoner panel with the updated costs
func _on_Button_pressed(card_selection):
	current_panel = SummonChoicesContainer
	
	SummonChoicesContainer.show()
	CardScrollContainer.hide()
	
	current_card_pack = card_selection
	rate_chart = [0]
	
	_determine_weight()
	_update_summon_choices(current_card_pack.card_cost)


# Determines the rates of the card pack
func _determine_weight():
	rate_dic["death_legend_rate"] = current_card_pack.death_legend_rate * 100
	rate_dic["life_legend_rate"] = current_card_pack.life_legend_rate * 100
	rate_dic["five_element_legend_rate"] = current_card_pack.five_element_legend_rate * 100
	rate_dic["death_epic_rate"] = current_card_pack.death_epic_rate * 100
	rate_dic["life_epic_rate"] = current_card_pack.life_epic_rate * 100
	rate_dic["five_element_epic_rate"] = current_card_pack.five_element_epic_rate * 100
	rate_dic["rare_rate"] = current_card_pack.rare_rate * 100
	rate_dic["uncommon_rate"] = current_card_pack.uncommon_rate * 100
	rate_dic["common_rate"] = current_card_pack.common_rate * 100
	
	# Initializes the rate chart with the weights
	for name in named_rates:
		var weight = rate_chart[-1] + rate_dic[name]
		rate_chart.append(weight)


# Updates the summoner panel according to the card_cost
func _update_summon_choices(card_cost):
	var one_time = $"SummonPanel/SummonChoicesPanel/SummonChoicesContainer/1xSummonPanel/SummonContainer/1xSummonCost"
	var five_time = $"SummonPanel/SummonChoicesPanel/SummonChoicesContainer/5xSummonPanel/SummonContainer/5xSummonCost"
	
	var cost_type = card_cost.split(" ")
	
	# Sets the one time and five times summon panels
	one_time.text = cost_type[0] + " " + cost_type[1]
	five_time.text = str(int(float(cost_type[0]) * 4.5)) + " " + cost_type[1]


# Summons from the pack once
func _on_1xSummon_pressed():
	# Checks if they can summon 1 card
	if CardsUI.can_summon(1):
		DrawnCardsDisplay.show()
		_draw_cards(1)
	else:
		ErrorMessagePanel.show()
		ErrorMessagePanel.get_node("ErrorMessageTimer").start()


# Summons from the pack five times
func _on_5xSummon_pressed():
	# Checks if they can summon 5 cards
	if CardsUI.can_summon(5):
		DrawnCardsDisplay.show()
		_draw_cards(5)
	else:
		ErrorMessagePanel.show()
		ErrorMessagePanel.get_node("ErrorMessageTimer").start()


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
	_display_drawn_cards(drawn_cards)


# Chooses the rarity and type of card
func _choose_rarity_type(random_draw):
	
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
	var card_pack = current_card_pack.get_card_pack()
	
	# Fills choose gods array with gods that match the rarity and type
	for god in card_pack:
		if type == "Five Element":
			if god[card_attribute["rarity"]] == rarity:
				if god[card_attribute["type"]] != "Death" and god[card_attribute["type"]] != "Life":
					choose_gods.append(god)
		else:
			if god[card_attribute["rarity"]] == rarity:
				if god[card_attribute["type"]] == type:
					choose_gods.append(god)
	
	# Randomly choose from the appropriate gods selection
	rng.randomize()
	var card = choose_gods[rng.randi() % len(choose_gods)]
	CardsUI.add_card(card)
	
	return card


# Displays the drawn cards
func _display_drawn_cards(drawn_cards):
	
	current_panel = DrawnCardsDisplay
	
	var card_container = CardDisplayContainer.get_children()
	
	for index in range(len(particle_systems)):
		particle_systems[index].hide()
		reveal_buttons[index].hide()
	
	# Clears the images in the draw display container
	for index in range(len(card_container)):
		var card_sprite = card_container[index].get_node("CardSprite")
		card_sprite.texture = null
	
	# If only one card is drawn it fills the center card slot
	if len(drawn_cards) == 1:
		var card_sprite = card_container[floor(len(card_container) / 2.0)].get_node("CardSprite")
		card_sprite.texture = load(drawn_cards[0][card_attribute["image"]])
		
		reveal_buttons[floor(len(card_container) / 2.0)].show()
		
		var card_rarity = drawn_cards[0][card_attribute["rarity"]]
		var card_type = drawn_cards[0][card_attribute["type"]]
		var particle = particle_systems[floor(len(card_container) / 2.0)]
		
		if card_rarity == "Legend" or card_rarity == "Epic":
			_set_particle_system(card_rarity, card_type, particle)
	# Else fills all five card slots
	else:
		for index in range(len(card_container)):
			var card_sprite = card_container[index].get_node("CardSprite")
			card_sprite.texture = load(drawn_cards[index][4])
			
			reveal_buttons[index].show()
			
			var card_rarity = drawn_cards[index][card_attribute["rarity"]]
			var card_type = drawn_cards[index][card_attribute["type"]]
			var particle = particle_systems[index]
			
			if card_rarity == "Legend" or card_rarity == "Epic":
				_set_particle_system(card_rarity, card_type, particle)


# Emits particles for legends and epics
func _set_particle_system(rarity, type, particle):
	particle.show()
	
	match rarity:
		"Legend":
			match type:
				"Death":
					particle.process_material.color = Color.black
				"Life":
					particle.process_material.color = Color.white
				"Wood":
					particle.process_material.color = Color.darkgreen
				"Fire":
					particle.process_material.color = Color.crimson
				"Earth":
					particle.process_material.color = Color.brown
				"Metal":
					particle.process_material.color = Color.gray
				"Water":
					particle.process_material.color = Color.blue
		"Epic":
			particle.process_material.color = Color.darkgray


# Shows the SummonUI
func _on_Summon_pressed():
	show()


# Hides the current panel
func _on_CloseSummon_pressed():
	match current_panel:
		CardScrollContainer:
			hide()
		CardListPanel:
			current_panel.hide()
			current_panel = CardScrollContainer
			current_panel.show()
			_reset_draw_rates()
		SummonChoicesContainer:
			current_panel.hide()
			current_panel = CardScrollContainer
			current_panel.show()
		DrawnCardsDisplay:
			current_panel.hide()
			current_panel = SummonChoicesContainer
			current_panel.show()


# Resets the draw rates panel
func _reset_draw_rates():
	var draw_button = CardListPanel.get_node("DrawRates")
	
	if draw_button.is_pressed():
		draw_button.set_pressed(false)


# Hides the error message
func _on_ErrorMessageTimer_timeout():
	ErrorMessagePanel.hide()


# Sets the current panel
func set_current_panel(panel):
	current_panel = panel


# Shows and hides the draw rates panel
func _on_DrawRates_toggled(button_pressed):
	var original_position = Vector2(25, 600)
	var target_position = Vector2(25, 250)
	
	if button_pressed:
		DrawRatesPanel.move(target_position)
	else:
		DrawRatesPanel.move(original_position)
