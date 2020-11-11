extends Node

var path = "user://Player/PlayerInfo.json"
var player_info = {}

var default_player_info = {
	"ID": 0000000000,
	"name": "Default Name",
	"icon": null,
	"total_contribution": 0,
	"weekly_contribution": 0,
	"honor": 0,
	"influence": 0,
	"homeland": "Home",
	"position": null,
	"kingdom": null,
	"gold": 0,
	"gems": 0
	}

const INFO_DIR = "user://Player/"


func _ready():
	player_info = load_player_info()
	save_player_info()


# Loads the player info
func load_player_info():
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
		text = default_player_info
	
	return text


# Saves the player info
func save_player_info():
	var dir = Directory.new()
	
	if !dir.dir_exists(INFO_DIR):
		dir.make_dir_recursive(INFO_DIR)
	
	var file = File.new()
	var error = file.open(path, File.WRITE)
	
	if error == OK:
		file.store_line(to_json(player_info))
		file.close()
	else:
		print(error)


# Gets the player id
func get_player_id():
	return player_info["ID"]


# Sets the player name
func set_player_name(p_name):
	player_info["name"] = p_name
	save_player_info()


# Sets the player icon
func set_player_icon(p_icon):
	player_info["icon"] = p_icon
	save_player_info()


# Sets the player's total contribution
func set_player_total_contributions(contribution, add):
	if add:
		player_info["total_contribution"] += contribution
	else:
		player_info["total_contribution"] = 0
	
	save_player_info()


# Sets the player's weekly contribution
func set_player_weekly_contributions(contribution, add):
	if add:
		player_info["weekly_contribution"] += contribution
	else:
		player_info["weekly_contribution"] = 0
	
	save_player_info()


# Sets the player's honor
func set_player_honor(honor, add):
	if add:
		player_info["honor"] += honor
	else:
		player_info["honor"] = 0
	
	save_player_info()


# Sets the player's homeland
func set_player_homeland(homeland):
	player_info["homeland"] = homeland
	save_player_info()


# Sets the player's position
func set_player_position(position):
	player_info["position"] = position
	save_player_info()


# Sets the player's kingdom
func set_player_kingdom(kingdom):
	player_info["kingdom"] = kingdom
	save_player_info()


# Sets the player's gold
func set_player_gold(amount, add):
	if add:
		player_info["gold"] += amount
	else:
		if player_info["gold"] - amount < 0:
			return false
		else:
			player_info["gold"] -= amount
	
	save_player_info()
	return true


# Sets the player's gold
func set_player_gems(amount, add):
	if add:
		player_info["gems"] += amount
	else:
		if player_info["gems"] - amount < 0:
			return false
		player_info["gems"] -= amount
	
	save_player_info()
	return true


# Gets the player's complete info
func get_player_info():
	return player_info
