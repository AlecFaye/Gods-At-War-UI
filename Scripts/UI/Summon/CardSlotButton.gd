extends Button


export(int) var card_draw_limit
export(int) var current_draw


export(String) var card_rarity
export(String) var card_name
export(String) var cost_type
export(String) var card_cost

export(float) var death_legend_rate
export(float) var life_legend_rate
export(float) var five_element_legend_rate
export(float) var death_epic_rate
export(float) var life_epic_rate
export(float) var five_element_epic_rate
export(float) var rare_rate
export(float) var uncommon_rate
export(float) var common_rate

export(String) var card_pack_path

# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

onready var rarity_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/RarityLabel
onready var card_summon_name_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CardSummonNameLabel
onready var cost_sprite = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CostContainer/SpriteHolder/CostSprite
onready var cost_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CostContainer/CostLabel

onready var SummonUI = $"../../../.."
onready var CardListPanel = $"../../../../CardListPanel"
onready var CardContainer = $"../../../../CardListPanel/BackgroundPanel/ScrollContainer/RowContainer"

var card_pack
var card_slots = []
var labels = []
var rates = []


func _ready():
	rarity_label.text = card_rarity
	card_summon_name_label.text = card_name
	cost_label.text = card_cost
	
	card_pack = get_from_json(card_pack_path)
	
	_get_card_slots()
	_get_rate_labels()
	_append_rates()
	
	match cost_type:
		"Gems":
			cost_sprite.texture = load("res://Sprites/GameUISprites/Gems.png")
		"Gold":
			cost_sprite.texture = load("res://Sprites/GameUISprites/Gold.png")


# Gets the card slots for the Cards List Panel
func _get_card_slots():
	var rows = CardContainer.get_children()
	var buttons = []
	
	for row in rows:
		buttons.append(row.get_children())
	
	for current_button in buttons:
		for sprite in current_button:
			card_slots.append(sprite.get_node("CardSprite"))


# Gets the rate labels
func _get_rate_labels():
	var DrawRatesPanel = CardListPanel.get_node("DrawRatesPanel/RateLabelContainer")
	var rows = DrawRatesPanel.get_children()
	labels = []
	
	for row in rows:
		var label = row.get_node("Rate")
		labels.append(label)


# Appends the rates to the rates array
func _append_rates():
	rates.append(death_legend_rate)
	rates.append(life_legend_rate)
	rates.append(five_element_legend_rate)
	rates.append(death_epic_rate)
	rates.append(life_epic_rate)
	rates.append(five_element_epic_rate)
	rates.append(rare_rate)
	rates.append(uncommon_rate)
	rates.append(common_rate)


# Displays the card list
func _display_card_list():
	for index in range(len(card_slots)):
		card_slots[index].texture = null
		card_slots[index].get_parent().hide()
	
	for index in range(len(card_pack)):
		card_slots[index].texture = load(card_pack[index][4])
		card_slots[index].get_parent().show()


# Sets the draw rates
func _set_draw_rates():
	for index in range(len(labels)):
		labels[index].text = str(rates[index]) + "%"


# Reads file from Gods.json
func get_from_json(filename):
	var file = File.new()
	var error = file.open(filename, File.READ)
	
	if error == OK:
		var text = file.get_as_text()
		var data = parse_json(text)
		file.close()
		return data


# Resets the scroll container
func _reset_scroll():
	var scrollbar = CardContainer.get_parent().get_v_scrollbar()
	CardContainer.get_parent().scroll_vertical = scrollbar.min_value


# Called when the CardsList button is pressed
func _on_CardList_pressed():
	SummonUI.set_current_panel(CARD_LIST)
	
	_display_card_list()
	_set_draw_rates()
	_reset_scroll()
	
	CardListPanel.get_node("CardPackName").text = card_name


# Returns the card pack
func get_card_pack():
	return card_pack
