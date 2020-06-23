extends Panel


# Enum to keep track of the panels
enum {SELF, SUMMON_CHOICES, DRAWN_CARDS, CARD_LIST}

# Enum fror the card's attributes
enum {NAME, RARITY, REGION, TYPE, IMAGE}

# Array for the particle systems
var particle_systems = []

# Array for the buttons to reveal cards
var reveal_buttons = []

# Array for the card sprite textures
var card_sprite_holders

# Variables to optimize code
onready var SummonUI = $"../.."
onready var cards_drawn_container = $CardsDrawnContainer


func _ready():
	_get_drawn_cards_children()


# Gets the particle systems for each card
func _get_drawn_cards_children():
	
	var textures = []
	var sprites = []
	
	card_sprite_holders = cards_drawn_container.get_children()
	
	for node in card_sprite_holders:
		if node is TextureRect:
			textures.append(node)
	
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

# Displays the drawn cards
func display_drawn_cards(drawn_cards):
	
	SummonUI.set_current_panel(DRAWN_CARDS)
	
	for index in range(len(particle_systems)):
		particle_systems[index].hide()
		reveal_buttons[index].hide()
	
	# Clears the images in the draw display container
	for index in range(len(card_sprite_holders)):
		var card_sprite = card_sprite_holders[index].get_node("CardSprite")
		card_sprite.texture = null
	
	# If only one card is drawn it fills the center card slot
	if len(drawn_cards) == 1:
		var sprite_index = floor(len(card_sprite_holders) / 2.0)
		var card_sprite = card_sprite_holders[sprite_index].get_node("CardSprite")
		card_sprite.texture = load(drawn_cards[0][IMAGE])
		
		reveal_buttons[sprite_index].show()
		
		var card_rarity = drawn_cards[0][RARITY]
		var card_type = drawn_cards[0][TYPE]
		var particle = particle_systems[sprite_index]
		
		if card_rarity == "Legend":
			_set_particle_system(card_type, particle)
		else:
			reveal_buttons[sprite_index].hide()
	# Else fills all five card slots
	else:
		for index in range(len(card_sprite_holders)):
			var card_sprite = card_sprite_holders[index].get_node("CardSprite")
			card_sprite.texture = load(drawn_cards[index][4])
			
			reveal_buttons[index].show()
			
			var card_rarity = drawn_cards[index][RARITY]
			var card_type = drawn_cards[index][TYPE]
			var particle = particle_systems[index]
			
			if card_rarity == "Legend":
				_set_particle_system(card_type, particle)
			else:
				reveal_buttons[index].hide()


# Emits particles for legends and epics
func _set_particle_system(type, particle):
	particle.show()
	
	match type:
		"Death":
			particle.process_material.color = Color.black
		"Life":
			particle.process_material.color = Color.white
		"Wood":
			particle.process_material.color = Color.darkgreen
		"Fire":
			particle.process_material.color = Color.red
		"Earth":
			particle.process_material.color = Color.chocolate
		"Metal":
			particle.process_material.color = Color.darkgray
		"Water":
			particle.process_material.color = Color.darkturquoise
