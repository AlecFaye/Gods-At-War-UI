extends Control


onready var TextEditPanel = $EditTextPanel
onready var TextInsert = $MailTextDisplay/TextInsertContainer/TextInsert
onready var MessagesContainer = $MailTextDisplay/MailMessages/MessageContainer

var messages


func _ready():
	messages = MessagesContainer.get_children()


# When the mouse is pressed outside the input
func _input(event):
	if event is InputEventMouseButton:
		if event.position.y > 0 and event.position.y < 450:
			TextEditPanel.hide()
			TextInsert.release_focus()


# Shows the Mail UI
func _on_Mail_pressed():
	show()


# Hides the Mail UI
func _on_CloseMail_pressed():
	hide()


# Lets the user see the text they are typing
func _on_TextInsert_text_changed(new_text):
	var text_edit = TextEditPanel.get_node("TextEdit")
	text_edit.text = new_text


# When the text is focused
func _on_TextInsert_focus_entered():
	TextEditPanel.show()


# When the text exist focus
func _on_TextInsert_focus_exited():
	TextEditPanel.hide()
