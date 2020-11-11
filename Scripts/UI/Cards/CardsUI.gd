extends Control


# Variables to optimize code
onready var sort_panel = $SortPanel
onready var card_panel = $CardPanel
onready var filter_panel = $SacrificePanel/FilterPanel
onready var sacrifice_panel = $SacrificePanel
onready var sort_button = $SortButton

var player_cards = []  # Array to hold the player cards
var card_limit = 100   # Card slot limit
var current_panel = self


# Adds the card to the player cards
func add_card(card):
	player_cards.append(card)


# Checks if the summon is allowed to happen
func can_summon(summon_count):
	if len(player_cards) + summon_count > card_limit:
		return false
	return true


# Shows the CardsUI, sorts the cards and fill the card slots
func _on_Cards_pressed():
	current_panel = self
	sort_panel.sort()
	card_panel.fill_card_slots("name")
	show()


# Closes the CardsUI
func _on_CloseCards_pressed():
	
	filter_panel.hide_popups()
	
	if sort_button.is_pressed():
		sort_button.set_pressed(false)
		
	if current_panel != self:
		current_panel.hide()
		current_panel = self
	else:
		current_panel.hide()


# Shows the sort options
func _on_SortButton_toggled(button_pressed):
	
	var target_position = Vector2(35, 220)
	var original_position = Vector2(-150, 220)
	var move_panel
	
	if current_panel == self:
		move_panel = sort_panel
	elif current_panel == sacrifice_panel:
		move_panel = filter_panel
	
	if button_pressed:
		move_panel.move(target_position)
		sort_button.text = "<"
	else:
		move_panel.move(original_position)
		sort_button.text = ">"
		filter_panel.hide_popups()


# Gets the player cards
func get_player_cards():
	return player_cards


# When the sacrifice button is pressed
func _on_Sacrifice_pressed():
	if sort_button.is_pressed():
		sort_button.set_pressed(false)
	
	sacrifice_panel.show()
	sacrifice_panel.get_card_groups()
	sacrifice_panel.set_up_display_cards()
	
	current_panel = sacrifice_panel


# Sets the current panel
func set_current_panel(panel):
	current_panel = panel
