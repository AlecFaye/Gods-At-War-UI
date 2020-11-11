extends VBoxContainer


export (String) var skill_type
export (String) var skill_effect
export (String) var skill_cost
export (String) var skill_name
export (String) var skill_image
export (String) var skill_json

const IMAGE_PATH = "res://Sprites/SkillSprites/"
const LOCKED_IMAGE_PATH = "res://Sprites/SkillSprites/Locked/"
const INFO_PATH = "res://Files/Skills/"
const STATUS_DIR = "user://Skills/"

var skill_info           # Dictionary to hold the skill info
var skill_status         # Dictionary to hold the skill status
var default_status = {   # Default dictionary for skill status
	"locked": false,     # Boolean to check if the skill is locked
	"research_rate": 0,  # Integer to determine how much research was done
	"level": 0,          # Level of the skill on god
	"gods": []           # The gods that hold each skill
	}
var default_info = {
	"description": "",
	"damage": [],
	"upgrade": [],
	"percentage": [],
	
	"type": "",
	"range": "",
	"target": [],
	
	"rate": 0,
	"is_upgrading_rate": false,
	"rate_upgrade": 0,
	
	"limit": 1
}

var skill_path   # Path to the json files
var locked_path  # Path to the locked image
var image_path   # Path to the image png

var _description = "Insert Skill Description"
var _damage = [25]
var _upgrade = [5]
var _percentage = [true]

var _type = "Fire"
var _range = "3"
var _target = "2 Enemies"

var _rate = "25"
var _is_upgrading_rate = false
var _rate_upgrade = 2

var _limit = 2

var _gods = ["Hades", "Merlin"]
var _level = 0

onready var skill_info_panel = $"../../../../../SkillInfo2DNode/SkillInfoPanel"


func _ready():
	skill_path = skill_type + "/" + skill_json
	locked_path = skill_effect + skill_cost + ".png"
	image_path = skill_type + "/" + skill_image
	
	skill_info = _load_resource(INFO_PATH + skill_path)
	skill_status = _load_resource(STATUS_DIR + skill_path)
	
	_set_image()
	
	var name_label = $Control/Node2D/Name
	name_label.text = skill_name
	
	var button = $OpenSkillInfo
	button.connect("pressed", self, "_on_Skill_pressed")


# When a skill is pressed
func _on_Skill_pressed():
	_description = skill_info["description"]
	_damage = skill_info["damage"]
	_upgrade = skill_info["upgrade"]
	_percentage = skill_info["percentage"]
	
	_type = skill_info["type"]
	_range = skill_info["range"]
	_target = skill_info["target"]
	
	_rate = skill_info["rate"]
	_is_upgrading_rate= skill_info["is_upgrading_rate"]
	_rate_upgrade = skill_info["rate_upgrade"]
	
	_limit = skill_info["limit"]
	
	_gods = skill_status["gods"]
	_level = skill_status["level"]
	
	var sprite_path = IMAGE_PATH + image_path
	
	skill_info_panel.set_skill_info(
		skill_name,
		skill_effect,
		_description,
		_damage,
		_type,
		_range,
		_rate,
		_is_upgrading_rate, 
		_rate_upgrade,
		_target,
		_upgrade,
		_limit,
		_percentage,
		_gods,
		_level,
		sprite_path)


# Loads the skill info
func _load_resource(path):
	var file = File.new()
	var text
	
	if file.file_exists(path):
		var error = file.open(path, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
		else:
			print(File.error)
		file.close()
	else:
		if path == INFO_PATH + skill_path:
			text = default_info
		elif path == STATUS_DIR + skill_path:
			text = default_status
	
	return text


# Saves the skill info
func save_skill():
	var dir = Directory.new()
	
	if !dir.dir_exists(STATUS_DIR):
		dir.make_recursive(STATUS_DIR)
	
	var path = STATUS_DIR + skill_path + ".json"
	var file = File.new()
	var error = file.open(path, File.WRITE)
	
	if error == OK:
		file.store_line(to_json(skill_status))
	else:
		print(error)
	file.close()


# Sets the image sprite
func _set_image():
	var sprite = get_node("OpenSkillInfo/Sprite")
	if skill_status["locked"]:
		sprite.texture = load(LOCKED_IMAGE_PATH + locked_path)
	else:
		sprite.texture = load(IMAGE_PATH + image_path)


# Adds god to the skill holder
# 	god(int): Unique ID of the player's god
func add_god_to_skill(godID):
	var god_holder = skill_status["gods"]
	
	if len(god_holder) + 1 > _limit:
		return false
	else:
		god_holder.append(godID)
	
	return true
