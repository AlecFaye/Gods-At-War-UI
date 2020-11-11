extends "res://Scripts/Player.gd"


var original_position = Vector2(0, 0)
var target_position = Vector2(0, 40)

const WIDTH = 1024  # Original screen width

onready var gems_count = $"../SpecialResources/Gems"
onready var gold_count = $"../SpecialResources/Gold/GoldCount"


func _ready():
	_set_topUI()
	set_special_resources()


# Sets the special resources
func set_special_resources():
	gems_count.text = str(player_info["gems"])
	gold_count.text = str(player_info["gold"])


# Extends the top UI panel
func _set_topUI():
	var screen_width = get_viewport().get_visible_rect().size[0]
	var game_ratio = float(screen_width) / float(WIDTH)
	
	var topUI = $UITOPControl/UITOP
	var x_scale = topUI.get_scale()[0]
	var y_scale = topUI.get_scale()[1]
	
	var updated_scale = Vector2(x_scale * game_ratio, y_scale)
	topUI.set_scale(updated_scale)


# Animates the territory panel
func _on_Territory_toggled(button_pressed):
	
	var TerritoryPanel = $TerritoryTimeContainer/Territory/TerritoryCountPanel
	
	if button_pressed:
		TerritoryPanel.move(target_position)
	else:
		TerritoryPanel.move(original_position)


# Animates the server time panel
func _on_ServerTime_toggled(button_pressed):
	
	var ServerTimePanel = $TerritoryTimeContainer/ServerTime/ServerTimePanel
	
	if button_pressed:
		ServerTimePanel.move(target_position)
	else:
		ServerTimePanel.move(original_position)


# Animates the local time panel
func _on_LocalTime_toggled(button_pressed):
	
	var LocalTimePanel = $TerritoryTimeContainer/LocalTime/LocalTimePanel
	
	if button_pressed:
		LocalTimePanel.move(target_position)
	else:
		LocalTimePanel.move(original_position)


# Adds 5000 gold
func _on_Add5000Gold_pressed():
	set_player_gold(5000, true)
