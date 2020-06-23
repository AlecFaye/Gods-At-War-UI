extends Control


# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

# Keeps track of the current panel open
var current_panel

# Array to hold the panels
var panels = []

# List of panels
onready var summon_panel = $SummonPanel
onready var summon_choices_panel = $SummonPanel/SummonChoicesPanel
onready var drawn_cards_panel = $SummonPanel/DrawnCardsPanel
onready var card_list_panel = $CardListPanel
onready var draw_rates_panel = $CardListPanel/DrawRatesPanel
onready var special_resource_panel = $SpecialResourcePanel

# Tracks the gem count
onready var player_gems = $"../GameScreenUI/BottomPanel/Gems"
onready var gem_count = $SpecialResourcePanel/ResourceContainer/Gems


# Finds all the card packs in the card container when loading the game
func _ready():
	_append_panels()


# Populates the panels
func _append_panels():
	panels.append(self)
	panels.append(summon_choices_panel)
	panels.append(drawn_cards_panel)
	panels.append(card_list_panel)


# Shows the SummonUI
func _on_Summon_pressed():
	current_panel = SELF
	panels[current_panel].show()
	
	# Sets the gem count to what is given on the GameScreenUI
	gem_count.text = player_gems.text


# Hides the current panel
func _on_CloseSummon_pressed():
	match current_panel:
		SELF:  
			panels[current_panel].hide()
		SUMMON_CHOICES:  
			panels[current_panel].hide()
			current_panel = SELF
			panels[current_panel].show()
		DRAWN_CARDS:
			panels[current_panel].hide()
			current_panel = SUMMON_CHOICES
			panels[current_panel].show()
		CARD_LIST:
			panels[current_panel].hide()
			current_panel = SELF
			panels[current_panel].show()
			
			_reset_draw_rates()
			special_resource_panel.show()


# Sets the current panel
func set_current_panel(index):
	current_panel = index
	panels[current_panel].show()
	
	if index == CARD_LIST:
		special_resource_panel.hide()


# Resets the draw rates panel
func _reset_draw_rates():
	var draw_button = card_list_panel.get_node("DrawRates")
	
	if draw_button.is_pressed():
		draw_button.set_pressed(false)


# Shows and hides the draw rates panel
func _on_DrawRates_toggled(button_pressed):
	var original_position = Vector2(25, 600)
	var target_position = Vector2(25, 250)
	
	if button_pressed:
		draw_rates_panel.move(target_position)
	else:
		draw_rates_panel.move(original_position)
