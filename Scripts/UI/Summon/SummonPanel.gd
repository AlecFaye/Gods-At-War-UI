extends Panel


# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

# Keeps track of the current card pack
var current_card_pack

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

onready var SummonUI = $".."

# Variables to optimize code
onready var card_container = $CardScrollContainer/CardContainer
onready var scroll_container = $CardScrollContainer
onready var summon_choices_panel = $SummonChoicesPanel


func _ready():
	_get_card_packs_buttons()


# Gets the card pack buttons
func _get_card_packs_buttons():
	for card_selection in card_container.get_children():
		card_selection.connect("pressed", self, "_on_Button_pressed", [card_selection])


# Shows the summoner panel with the updated costs
func _on_Button_pressed(card_selection):
	SummonUI.set_current_panel(SUMMON_CHOICES)
	
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
	var one_time = $"SummonChoicesPanel/SummonChoicesContainer/1xSummonPanel/SummonContainer/1xSummonCost"
	var five_time = $"SummonChoicesPanel/SummonChoicesContainer/5xSummonPanel/SummonContainer/5xSummonCost"
	
	var cost_type = card_cost.split(" ")
	
	# Sets the one time and five times summon panels
	one_time.text = cost_type[0] + " " + cost_type[1]
	five_time.text = str(int(float(cost_type[0]) * 4.5)) + " " + cost_type[1]


# Gets the rate chart
func get_rate_chart():
	return rate_chart


# Get the named rates
func get_named_rates():
	return named_rates


# Gets the current card pack
func get_current_card_pack():
	return current_card_pack
