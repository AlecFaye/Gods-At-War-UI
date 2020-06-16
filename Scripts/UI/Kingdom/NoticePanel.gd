extends Panel


onready var NoticeEditPanel = $NoticeEditPanel
onready var NoNoticePanel = $VBoxContainer/NoticeBox/NoNoticePanel

onready var notice_box = $VBoxContainer/NoticeBox
onready var text_edit = $NoticeEditPanel/TextEdit


func _ready():
	_notice_visible()


# Checks if there is a notice text
func _notice_visible():
	if notice_box.text == "":
		NoNoticePanel.show()
	else:
		NoNoticePanel.hide()


# When the edit button is pressed
func _on_Edit_pressed():
	NoticeEditPanel.show()


# When the close edit button is pressed
func _on_CloseNoticeEdit_pressed():
	NoticeEditPanel.hide()


# When the user inputs letters
func _on_LineEdit_text_changed(new_text):
	text_edit.text = new_text


# When the confirm button is pressed
func _on_Confirm_pressed():
	notice_box.text = text_edit.text
	NoticeEditPanel.hide()
	_notice_visible()
