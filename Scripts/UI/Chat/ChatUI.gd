extends Control


# Variables to optimize code
onready var UserInput = $ChatElements/ChatInteractions/UserInput
onready var SendButton = $ChatElements/ChatInteractions/Send
onready var ChatOptions = $ChatElements/ScrollContainer/ChatOptions
onready var ChatMessages = $ChatElements/ChatPanel/ScrollContainer/ChatMessages
onready var ChatScrollContainer = $ChatElements/ChatPanel/ScrollContainer
onready var TextEditPanel = $TextEditPanel

# Positions for the chat to move towards
var original_position = Vector2(-450, 0)
var target_position = Vector2(0, 0)

# Current textbox
onready var current_chat = $ChatElements/ScrollContainer/ChatOptions/WorldChat
var chat_messages = []


# Run at the beginning of the game
func _ready():
	_get_button_label_info()


# Gets the chat buttons and the message labels in the chat box
func _get_button_label_info():
	for chat_box in ChatOptions.get_children():
		chat_box.connect("pressed", self, "_on_Button_pressed", [chat_box])
	for label in ChatMessages.get_children():
		chat_messages.append(label)


# Sets up the current chat box by clearing the current chat box and updating it to the new one
func _on_Button_pressed(chat_box):
	_clear_chat_box()
	current_chat = chat_box
	_update_chat_box()
	
	# Always has the chat be scrolled to the bottom
	var scrollbar = ChatScrollContainer.get_v_scrollbar()
	ChatScrollContainer.scroll_vertical = scrollbar.max_value


# Clears the message box
func _clear_chat_box():
	for message in chat_messages:
		message.text = " "
		
		var time = message.get_node("Time")
		time.text = "99:99:99"


# Updates the current chat box
func _update_chat_box():
	var current_chat_messages = current_chat.get_chat_messages()
	var current_chat_time = current_chat.get_chat_time()
	
	# Displays the messages and time stamp
	for index in range(len(current_chat_messages)):
		var chat = chat_messages[index]
		var time = chat.get_node("Time")
		
		chat.text = current_chat_messages[index]
		time.text = current_chat_time[index]
	
	# Hides any time stamps with 99:99:99
	for index in range(len(chat_messages)):
		var time = chat_messages[index].get_node("Time")
		if time.text == "99:99:99":
			time.hide()
		else:
			time.show()


# When the send button is pressed
func _on_Send_pressed():
	# Gets the message
	var message = UserInput.text
	UserInput.clear()
	
	# Gets the time
	var time_dict = OS.get_time(true)
	var hour = str(time_dict.hour)
	var minute = str(time_dict.minute)
	var second = str(time_dict.second)
	
	if len(hour) == 1:
		hour = "0" + hour
	if len(minute) == 1:
		minute = "0" + minute
	if len(second) == 1:
		second = "0" + second
	
	var time = hour + ":" + minute + ":" + second
	
	# Adds the message to the array and update the chat box
	if len(message) > 0:
		current_chat.add_message(message)
		current_chat.add_time(time)
		_update_chat_box()


# Closes the chat if the mouse is outside the chat box
func _input(event):
	if self.rect_position.x == 0:
		if event is InputEventMouseButton:
			if event.position.x > rect_size.x:
				_move(original_position)
				TextEditPanel.hide()


# Opens the chat
func _on_Chat_pressed():
	_move(target_position)
	_update_chat_box()


# Closes the chat
func _on_CloseChat_pressed():
	_move(original_position)


# Moves the chat to the target position and the original position
func _move(target):
	var ChatTween = $ChatTween
	ChatTween.interpolate_property(self, "rect_position", rect_position, target, 1.5, Tween.TRANS_QUINT, Tween.EASE_OUT)
	ChatTween.start()


# When the user clicks on the text input
func _on_UserInput_focus_entered():
	TextEditPanel.show()


# When the user clicks out of the text input
func _on_UserInput_focus_exited():
	TextEditPanel.hide()


# When the user changes the text field
func _on_UserInput_text_changed(new_text):
	var text_edit = TextEditPanel.get_node("TextEdit")
	text_edit.text = new_text
