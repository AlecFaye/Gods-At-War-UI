extends Control


# Variables to optimize code
onready var sort_panel = $SortPanel
onready var card_panel = $CardPanel
onready var sacrifice_panel = $SacrificePanel
onready var sort_button = $SortButton

var player_cards = []  # Array to hold the player cards
var card_limit = 100   # Card slot limit


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
	sort_panel.sort()
	card_panel.fill_card_slots("name")
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


# When the sacrifice button is pressed
func _on_Sacrifice_toggled(button_pressed):
	if button_pressed:
		sacrifice_panel.show()
	else:
		sacrifice_panel.hide()


# Gets the player cards
func get_player_cards():
	return player_cards
