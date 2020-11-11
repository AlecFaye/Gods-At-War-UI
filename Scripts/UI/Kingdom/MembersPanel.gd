extends Panel


var members_holder = []
var members_info = []

const INFO_DIR = "user://Kingdom/"
const INFO_PATH = "user://Kingdom/MemberInfo.json"

onready var popup = $VBoxContainer/OptionsContainer/FilterButton/Filter
onready var options_container = $VBoxContainer/OptionsContainer
onready var members_container = $VBoxContainer/ScrollContainer/MembersContainer


func _ready():
	_get_options_buttons()
	_set_up_popup()
	members_holder = members_container.get_children()
	members_info = _load_kingdom_members()
	_set_up_members()


# Sets up the members info
func _set_up_members():
	_hide_members_holder()
	
	for index in range(len(members_info)):
		var member = members_info[index]
		
		members_holder[index].set_up_member_info(
			member["name"],
			member["icon"],
			member["total_contribution"],
			member["weekly_contribution"],
			member["honor"],
			member["influence"],
			member["homeland"],
			member["position"])
		
		members_holder[index].show()


# Hides the member panels
func _hide_members_holder():
	for index in range(len(members_holder)):
		members_holder[index].hide()


# Adds a player to their kingdom
func _add_member(member):
	members_info.append(member)
	members_info.sort_custom(self, "_position_comparison")
	_save_kingdom_members()
	_set_up_members()


# Sorts the player
func _position_comparison(a, b):
	var first = 0
	var second = 0
	
	match a["position"]:
		"King":
			first = 1
		"Queen":
			first = 2
		"Head Advisor":
			first = 3
		"Head Commander":
			first = 4
		"Strategist":
			first = 5
		"Officer":
			first = 6
		"Member": 
			first = 10
	
	match b["position"]:
		"King":
			second = 1
		"Queen":
			second = 2
		"Head Advisor":
			second = 3
		"Head Commander":
			second = 4
		"Strategist":
			second = 5
		"Officer":
			second = 6
		"Member": 
			second = 10
	
	return first < second


# Loads the kingdom member's info
func _load_kingdom_members():
	var file = File.new()
	var text
	
	if file.file_exists(INFO_PATH):
		var error = file.open(INFO_PATH, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
			file.close()
		else:
			print(error)
	else:
		text = []
	
	return text


# Saves the kingndom member's info
func _save_kingdom_members():
	var dir = Directory.new()
	
	if !dir.dir_exists(INFO_DIR):
		dir.make_dir_recursive(INFO_DIR)
	
	var file = File.new()
	var error = file.open(INFO_PATH, File.WRITE)
	
	if error == OK:
		file.store_line(to_json(members_info))
		file.close()
	else:
		print(error)


# Gets the option's buttons
func _get_options_buttons():
	for option in options_container.get_children():
		option.connect("pressed", self, "_on_Option_pressed", [option.name])


# When an option is pressed
func _on_Option_pressed(name):
	match name:
		"Member":
			pass
		"Group":
			pass
		"Applications":
			pass
		"Invite":
			pass
		"PlayerInfo":
			pass
		"FilterButton":
			popup.show()


# Sets up the popup menu
func _set_up_popup():
	var position = popup.rect_position
	
	popup.clear()
	
	popup.add_item("Default", 1)
	popup.add_item("Contribution", 2)
	popup.add_item("Influence", 3)
	popup.add_item("Honor", 4)
	
	popup.set_position(popup.get_parent().rect_position + position)
	
	popup.connect("id_pressed", self, "_popupMenuChoice")


# If a choice is chosen on the popup menu
func _popupMenuChoice(popup_ID):
	
	var sort_attribute
	
	match popup_ID:
		1:
			sort_attribute = "Default"
		2:
			sort_attribute = "Contribution"
		3:
			sort_attribute = "Influence"
		4:
			sort_attribute = "Honor"
	
	popup.get_parent().text = sort_attribute
