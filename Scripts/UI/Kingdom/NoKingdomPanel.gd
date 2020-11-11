extends "res://Scripts/Player.gd"


var cooldown = 0

const GOV_COURT_REQUIREMENT = 3
const GOLD_INVESTMENT_REQUIREMENT = 5000


# Refers to itself
onready var no_kingdom_panel = $"."
onready var government_panel = $"../../GovernmentUI/GovernmentPanel"
onready var error_panel = $ErrorPanel
onready var kingdom_info_panel = $"../KingdomInfoPanel"

onready var kingdom_name = $CreateKingdomContainer/Info/VBoxContainer/NameLanguageContainer/KingdomNameInput
onready var kingdom_region = $CreateKingdomContainer/Info/VBoxContainer/HomelandContainer/Homeland
onready var cooldown_count = $CreateKingdomContainer/Info/VBoxContainer/CreateKingdomPanel/CooldownContainer/CooldownTimerLabel
onready var cooldown_timer = $CreateKingdomContainer/Info/VBoxContainer/CreateKingdomPanel/CooldownContainer/CooldownTimer
onready var create_kingdom_button = $CreateKingdomContainer/Info/VBoxContainer/CreateKingdomPanel/Control/CreateKingdomButton
onready var error_timer = $ErrorPanel/ErrorTimer


func _ready():
	_show_kingdom_homeland()


# Shows the kingdom homeland
func _show_kingdom_homeland():
	kingdom_region.text = player_info["homeland"]


# Checks if the player is in a kingdom
func is_in_kingdom():
	if player_info["kingdom"] == null:
		no_kingdom_panel.show()
		return true
	else:
		no_kingdom_panel.hide()
		return false


# Checks if the kingdom meets the requirements, if so, create the kingdom
func _on_CreateKingdomButton_pressed():
	var building_levels = government_panel.get_building_levels()
	
	if building_levels["Government Court"] >= 3 and cooldown == 0 and \
			player_info["gold"] >= 5000 and \
			len(kingdom_name.text) >= 4 and len(kingdom_name.text) <= 20:
		set_player_kingdom(kingdom_name.text)
		kingdom_info_panel.show()
		no_kingdom_panel.hide()
	else:
		error_panel.show()
		error_timer.start()


# Hides the error panel
func _on_ErrorTimer_timeout():
	error_panel.hide()
