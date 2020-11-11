extends Panel


var building_levels
var default_levels = {
	"Government Court": 0,
	"Drill Grounds": 0,
	"Taxes": 0,
	"Recruitment Time": 0,
	"Resource Storage": 0,
	"Siege Smith": 0,
	"Defense Camp": 0,
	"Speed Camp": 0,
	"Territory Expansion": 0,
	"City Militia Conscription": 0,
	"Attack Camp": 0,
	"Special Attack Camp": 0,
	"Road Maker": 0,
	"Barracks": 0,
	"Fort Militia Conscription": 0,
	"Fort Troop Deployment": 0,
	"Fort Rate Deployment": 0,
	"Nordic Realm Bonus": 0,
	"Roman Realm Bonus": 0,
	"Egyptian Realm Bonus": 0,
	"Hindu Realm Bonus": 0,
	"Japanese Realm Bonus": 0,
	"Chinese Realm Bonus": 0,
	"American Realm Bonus": 0,
	"Water Bonus": 0,
	"Metal Bonus": 0,
	"Fire Bonus": 0,
	"Life Bonus": 0,
	"Wood Bonus": 0,
	"Earth Bonus": 0,
	"Death Bonus": 0,
	"Guard Defense": 0,
	"Guard Attack": 0,
	"Guard Spec Attack": 0,
	"Fort Masonry": 0,
	"Tavern": 0
	}
var path_name = "Building Levels.json"

const LEVEL_DIR = "user://Buildings/Level/"


func _ready():
	building_levels = _load_building_levels(LEVEL_DIR + path_name)


# Loads the building levels
func _load_building_levels(path):
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
		text = default_levels
	
	return text


# Saves the building levels
func _save_building_levels():
	var dir = Directory.new()
	
	if !dir.dir_exists(LEVEL_DIR):
		dir.make_dir_recursive(LEVEL_DIR)
	
	var file = File.new()
	var error = file.open(LEVEL_DIR + path_name, File.WRITE)
	
	if error == OK:
		file.store_line(to_json(building_levels))
		file.close()
	else:
		print(error)


# Sets the building level
func set_building_level(building, _level):
	building_levels[building] = _level
	_save_building_levels()


# Returns the building levels
func get_building_levels():
	return building_levels
