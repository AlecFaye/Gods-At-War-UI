extends Button


const CHAT_DIR = "user://Chat/"

export(String) var chat_path
export(String) var chat_name

var chat_messages = []
var message_limit = 25


func _ready():
	self.text = chat_name
	chat_path = CHAT_DIR + chat_path
	chat_messages = _load_messages()


# Adds a message to the chat messages
func add_message(message):
	if len(chat_messages) == message_limit:
		chat_messages.remove(0)
	chat_messages.append(message)
	_save_messages(chat_messages)


# Saves the messages to a json file
func _save_messages(content):
	
	var dir = Directory.new()
	if !dir.dir_exists(CHAT_DIR):
		dir.make_dir_recursive(CHAT_DIR)
	
	var file = File.new()
	var error = file.open(chat_path, File.WRITE)
	if error == OK:
		file.store_line(to_json(content))
		file.close()
	else:
		print(error)


# Loads the messages from a json file
func _load_messages():
	var file = File.new()
	var text
	
	if file.file_exists(chat_path):
		var error = file.open(chat_path, File.READ)
		if error == OK:
			var content = file.get_as_text()
			text = parse_json(content)
			file.close()
		else:
			print(error)
	else:
		text = []
	
	return text


# Sets the chat name
func set_chat_name(name):
	chat_name = name
	self.text = name


# Returns the chat name
func get_chat_name():
	return chat_name


# Returns the chat messages
func get_chat_messages():
	return chat_messages
