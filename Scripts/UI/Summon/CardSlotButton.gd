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

export(String) var pack_json

const PACK_PATH = "res://Files/CardPacks/"

# Enum to keep track of card attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

onready var rarity_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/RarityLabel
onready var card_summon_name_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CardSummonNameLabel
onready var cost_sprite = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CostContainer/SpriteHolder/CostSprite
onready var cost_label = $PositionCardSlotPanel/GairoPictureHolder/CardContainer/CostContainer/CostLabel

onready var SummonUI = $"../../../.."
onready var CardListPanel = $"../../../../CardListPanel"

var card_pack
var rates = []


func _ready():
	rarity_label.text = card_rarity
	card_summon_name_label.text = card_name
	cost_label.text = card_cost
	
	card_pack = get_from_json(PACK_PATH + pack_json)
		
	_append_rates()
	
	match cost_type:
		"Gems":
			cost_sprite.texture = load("res://Sprites/GameUISprites/Gems.png")
		"Gold":
			cost_sprite.texture = load("res://Sprites/GameUISprites/Gold.png")


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


# Reads file from Gods.json
func get_from_json(filename):
	var file = File.new()
	var text
	
	if file.file_exists(filename):
		var error = file.open(filename, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
		else:
			print(File.error)
		file.close()
	else:
		var error_panel = $"../../../ErrorPanel"
		error_panel.show()
	
	return text


# Called when the CardsList button is pressed
func _on_CardList_pressed():
	SummonUI.set_current_panel(CARD_LIST)
	
	CardListPanel.display_card_list(card_pack)
	CardListPanel.set_draw_rates(rates)
	CardListPanel.set_name(card_name)


# Returns the card pack
func get_card_pack():
	return card_pack
