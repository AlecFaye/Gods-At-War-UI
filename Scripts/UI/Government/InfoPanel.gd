extends Panel


var building               # Holds the building type
var default_building_time  # Holds the default building time

var is_upgrading           # Checks if the building is undergoing upgrades
var upgrade_requirements   # Array to hold the building requirement nodes
var requirement_keys       # Array to hold the keys of the requirement dict
var requirement_info       # Dictionary to hold the requirement info

# Dims the UI when a skill is pressed
var original_color = Color(1, 1, 1, 1)
var dimmed_color = original_color.darkened(0.5)

onready var GovernmentUI = $"../.."
onready var government_panel = $"../../GovernmentPanel"
onready var upgrade_error_panel = $UpgradeErrorPanel

onready var infra_name = $Name
onready var close_infra_button = $CloseInfrastrucutreInfo

onready var pre_upgrade = $HBoxContainer/PreUpgrade
onready var post_upgrade = $HBoxContainer/PostUpgrade

onready var upgrade_costs = $UpgradeCostPanel/UpgradeCost
onready var building_requirements = $BuildingRequirements/VBoxContainer
onready var max_level_label = $UpgradeCostPanel/MaxLevelLabel
onready var upgrade_label = $UpgradeRequirementsLabel

onready var time_panel = $TimePanel
onready var upgrade_button = $Upgrade
onready var speed_up_button = $SpeedUp


func _ready():
	_set_panel_position()
	upgrade_requirements = building_requirements.get_children()


# Sets the position of the panel
func _set_panel_position():
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	
	var x = width/2 - self.rect_size.x/2
	var y = height/2 - self.rect_size.y/2
	
	self.rect_position = Vector2(x, y)


# Sets the info for the panel
# 	infrastructure (Scene):  building
# 	name (str):              building name
# 	level (int):             current building level
# 	effect1 (str):           current effect
# 	effect2 (str):           post upgrade effect
# 	costs (Array[int]):      upgrade costs
# 	sprite (Sprite):         building sprite
# 	time (int):              upgrade time
# 	upgrading (bool):        if the building is upgrading or not
# 	requirement_info (Dict)  requirements to upgrade
func set_info(infrastructure, name, level, effect_1, effect_2, costs, sprite, _upgrade_time, _current_time, upgrading, req_info):
	
	# Gets the building itself
	building = infrastructure
	
	# Sets the name of the building
	infra_name.text = name
	
	# Sets the pre level
	var pre_level = pre_upgrade.get_node("Panel/Level")
	pre_level.text = str(level)
	
	# Sets the pre sprite
	var pre_sprite = pre_upgrade.get_node("Sprite")
	pre_sprite.texture = sprite.texture
	
	# Sets the pre effect
	var pre_effect = pre_upgrade.get_node("Effect")
	pre_effect.text = effect_1
	
	# If the building is not at max level
	if effect_2 != "FINISHED":
		_enable_post_info(true)
		
		# Sets the post level
		var post_level = post_upgrade.get_node("Panel/Level")
		post_level.text = str(level + 1)
		
		# Sets the post sprite
		var post_sprite = post_upgrade.get_node("Sprite")
		post_sprite.texture = sprite.texture
		
		# Sets the post effect
		var post_effect = post_upgrade.get_node("Effect")
		post_effect.text = effect_2
		
		# Sets the upgrades
		var upgrades = upgrade_costs.get_children()
		for index in range(len(upgrades)):
			var count = upgrades[index].get_node("Count")
			count.text = "99999999" + "/" + str(costs[index])
	else:
		_enable_post_info(false)
	
	is_upgrading = upgrading
	default_building_time = _upgrade_time
	
	# If the infrastructure is being upgraded or not
	if is_upgrading:
		upgrade_button.text = "Cancel"
		set_speed_up_visible(true)
		set_time(_current_time)
	else:
		upgrade_button.text = "Upgrade"
		set_time(default_building_time)
		set_speed_up_visible(false)
	
	
	# Get and set up the upgrade requirements
	requirement_keys = Array(req_info.keys())
	requirement_info = req_info
	_set_up_requirements()
	
	GovernmentUI.dim_background(dimmed_color)
	show()


# Sets up the requiremnet nodes
func _set_up_requirements():
	for requirement in upgrade_requirements:
		for node in requirement.get_children():
			node.text = " "
	
	for index in range(len(requirement_keys)):
		var requirement_node = upgrade_requirements[index]
		var level = requirement_node.get_node("Level")
		var name = requirement_node.get_node("Name")
		
		var key = requirement_keys[index]
		level.text = "Lv. " + str(requirement_info[key])
		name.text = key


# Shows or hides certain info when at max level
# 	show (bool)
# 		true: shows the info
# 		false: hides the info
func _enable_post_info(show):
	if show:
		post_upgrade.show()
		max_level_label.hide()
		upgrade_costs.show()
		upgrade_button.show()
		time_panel.show()
		upgrade_label.show()
		building_requirements.get_parent().show()
	else:
		post_upgrade.hide()
		max_level_label.show()
		upgrade_costs.hide()
		upgrade_button.hide()
		time_panel.hide()
		upgrade_label.hide()
		building_requirements.get_parent().hide()


# Sets the time left label
# 	_time (int):  time in seconds
func set_time(_time):
	var time_left = time_panel.get_node("TimeLeft")
	var total_minutes = floor(_time / 60.0)
	
	var seconds = str(fmod(_time, 60.0))
	var minutes = str(fmod(total_minutes, 60.0))
	var hours = str(floor(total_minutes / 60.0))
	
	if len(seconds) == 1:
		seconds = str(0) + seconds
	if len(minutes) == 1:
		minutes = str(0) + minutes
	if len(hours) == 1:
		hours = str(0) + hours
	
	time_left.text = hours + " : " + minutes + " : " + seconds


# Starts the upgrade process
func _on_Upgrade_pressed():
	match upgrade_button.text:
		# If the builing can be upgraded and upgrade is pressed
		"Upgrade":
			if _upgradeable():
				building.start_upgrading(true)
				upgrade_button.text = "Cancel"
				set_speed_up_visible(true)
			else:
				upgrade_error_panel.show()
				var timer = upgrade_error_panel.get_node("HideErrorMessage")
				timer.start()
		
		# If the building is already being upgraded and cancel is pressed
		"Cancel":
			building.start_upgrading(false)
			upgrade_button.text = "Upgrade"
			set_time(default_building_time)
			set_speed_up_visible(false)


# Checks if the building can be upgraded
func _upgradeable():
	var building_levels = government_panel.get_building_levels()
	var can_upgrade = true
	
	for key in requirement_keys:
		if building_levels[key] < requirement_info[key]:
			can_upgrade = false
	
	return can_upgrade


# Updates the building timers
func _on_UpgradeBuildingsTimer_timeout():
	if is_upgrading:
		var current_time = building.get_current_time()
		if current_time > 0:
			set_time(current_time)


# When the speed up is pressed
func _on_SpeedUp_pressed():
	set_speed_up_visible(false)
	disable_upgrade(true)
	building.set_current_time(1)


# Hides the error message
func _on_HideErrorMessage_timeout():
	upgrade_error_panel.hide()


# Sets the upgrade status
func set_upgrade_status(currently_upgrading):
	is_upgrading = currently_upgrading


# Hides the infrastructure panel
func _on_CloseInfrastrucutreInfo_pressed():
	GovernmentUI.dim_background(original_color)
	hide()


# Gets the name
func get_name():
	return infra_name.text


# Hides the speedup button
func set_speed_up_visible(show):
	if show:
		speed_up_button.show()
	else:
		speed_up_button.hide()


# Enables and disables the button
func disable_upgrade(disable):
	upgrade_button.disabled = disable


# When the screen is clicked
func _input(event):
	if event is InputEventMouseButton:
		var x1 = self.rect_position.x
		var y1 = self.rect_position.y
		var x2 = x1 + self.rect_size.x
		var y2 = y1 + self.rect_size.y
		
		# Closes the infrastructure info panel
		if event.position.x < x1 or event.position.x > x2 or \
				event.position.y < y1 or event.position.y > y2:
			close_infra_button.emit_signal("pressed")
