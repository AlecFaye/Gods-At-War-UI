extends Panel


# Enums for the card attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

# Dictionary to keep rarity sorted when sorting by region or type
var rarity_dic = {
	"Legend": 0,
	"Epic": 1,
	"Rare": 2,
	"Uncommon": 3,
	"Common": 4
	}

# Dictionary to group the cards by rarity, region, and type
var card_groups = {
	"Legend": [],
	"Epic": [],
	"Rare": [],
	"Uncommon": [],
	"Common": [],
	"Hindu": [],
	"Japanese": [],
	"Chinese": [],
	"Roman": [],
	"Nordic": [],
	"Egyptian": [],
	"American": [],
	"Death": [],
	"Life": [],
	"Wood": [],
	"Fire": [],
	"Earth": [],
	"Metal": [],
	"Water": [],
	}

var sort_attribute = "name"

onready var CardsUI = $".."
onready var card_panel = $"../CardPanel"
onready var choice_container = $ChoiceContainer


func _ready():
	_get_sort_buttons()


# Gets the buttons in the sort panel
func _get_sort_buttons():
	for button in choice_container.get_children():
		button.connect("pressed", self, "_on_SortButton_pressed", [button.text])


# Determines the sorting attribute
func _on_SortButton_pressed(attribute):
	sort_attribute = attribute.to_lower()
	card_panel.fill_card_slots(sort_attribute)


# Organize by attribute given
func sort():
	var player_cards = CardsUI.get_player_cards()
	var rarity_sort = card_panel.get_rarity_sort()
	
	for card in card_groups:
		card_groups[card] = []
	
	# For loop to go through the attributes
	#	1 = rarity
	#	2 = region
	#	3 = type
	for sort_index in range(1, 4):
		
		# For loop to go through the player's cards
		for card_index in range(len(player_cards)):
			
			# Gets the attribute and appends it to the corresponding card group dictionary
			var attribute = player_cards[card_index][sort_index]
			card_groups[attribute].append(player_cards[card_index])
	
	# If the attribute isnt a rarity, sort them by rarity
	for attribute in card_groups:
		if not attribute in rarity_sort:
			card_groups[attribute].sort_custom(self, "_rarity_comparison")


# Rarity comparator for the card groups
func _rarity_comparison(a, b):
	var first = a[RARITY]
	var second = b[RARITY]
	
	return rarity_dic[first] < rarity_dic[second]


# Animates movement for the sort panel
func move(target):
	var SortTween = get_node("SortTween")
	SortTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	SortTween.start()


# Gets the card groups
func get_card_groups():
	return card_groups
