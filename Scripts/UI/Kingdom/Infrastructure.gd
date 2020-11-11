extends VBoxContainer


export(String) var building_name         # The building's name
export(String) var building_image_path   # Holds the image path
export(String) var building_json         # The json name file
export(int) var max_level                # Maximum building level

const IMAGE_PATH = "res://Sprites/GovernmentSprites/"
const UPGRADE_PATH = "res://Files/Buildings/Upgrade/"
const INFO_DIR = "user://Buildings/Info/"

# Enum to tell upgrade info
enum {EFFECT, WOOD, STONE, FOOD, TIME}

# Building Info variables
var level = 0
var upgrading = false

# Upgrade Info variables
var pre_effect
var post_effect
var upgrade_costs = []
var upgrade_time = -1
var current_time = -1

var upgrade_info
var building_info

onready var sprite = $OpenInfoPanel/Sprite
onready var label = $NamePanel/Node2D/Label
onready var open_infra_button = $OpenInfoPanel
onready var level_label = $NamePanel/Node2D/Panel/Level
onready var upgrade_timer = $UpgradeTimer

onready var infrastructure_panel = $"../../../../../../../InfrastrucutreInfo/InfoPanel"


func _ready():
	_load_image()
	
	upgrade_info = _load_upgrade_info(UPGRADE_PATH + building_json)
	building_info = _load_building_info(INFO_DIR + building_json)
	
	open_infra_button.connect("pressed", self, "_on_Infra_pressed")
	
	if len(building_info) > 0:
		level_label.text = str(building_info["level"])


# Loads the building info
func _load_upgrade_info(path):
	var file = File.new()
	var text
	
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
			file.close()
		else:
			print(error)
	else:
		text = []
	
	return text


# Loads the upgrade info
func _load_building_info(path):
	var file = File.new()
	var text
	
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
			file.close()
		else:
			print(error)
	else:
		text = {"level": 0, "upgrading": false}
	
	return text

# Saves the building info
func _save_building_info():
	var dir = Directory.new()
	
	if !dir.dir_exists(INFO_DIR):
		dir.make_dir_recursive(INFO_DIR)
	
	var file = File.new()
	var error = file.open(INFO_DIR + building_json, File.WRITE)
	
	if error == OK:
		file.store_line(to_json(building_info))
		file.close()
	else:
		print(error)


# Loads the image
func _load_image():
	sprite.texture = load(IMAGE_PATH + building_image_path)
	label.text = building_name


# Connects the infrastructure button
func _on_Infra_pressed():
	level = building_info["level"]
	upgrading = building_info["upgrading"]
	
	var upgrade_level = upgrade_info[str(level)]
	pre_effect = upgrade_level[EFFECT]
	
	if level != max_level:
		post_effect = upgrade_info[str(level + 1)][EFFECT]
	else: 
		post_effect = "FINISHED"
	
	upgrade_costs.clear()
	upgrade_costs.append(upgrade_level[WOOD])
	upgrade_costs.append(upgrade_level[STONE])
	upgrade_costs.append(upgrade_level[FOOD])
	
	upgrade_time = upgrade_level[TIME]
	
	infrastructure_panel.set_info(self, building_name, level, pre_effect, post_effect, upgrade_costs, sprite, upgrade_time, upgrading)


# Starts upgrading the infrastructure
func start_upgrading(is_upgrading):
	building_info["upgrading"] = is_upgrading
	infrastructure_panel.set_upgrade_status(is_upgrading)
	current_time = upgrade_time
	upgrade_timer.start()


# Updates the timer
func _on_UpgradeTimer_timeout():
	current_time = current_time - 1
	
	if current_time == 0:
		update_infrastructure()
		upgrade_timer.stop()
	
	_save_building_info()


# Updates the infrastructure
func update_infrastructure():
	building_info["level"] = level + 1
	building_info["upgrading"] = false
	
	level_label.text = str(level + 1)
	
	if infrastructure_panel.is_visible():
		if infrastructure_panel.get_name() == building_name:
			open_infra_button.emit_signal("pressed")


# Returns the current time
func get_current_time():
	return current_time


# Returns the building name
func get_building_name():
	return building_name
