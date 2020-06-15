extends Control


onready var OptionsContainer = $OptionsContainer

onready var Events = [$DailyLoginPanel, $EventsPanel, $SeasonPanel, $WorldPanel, $StatePanel]


func _ready():
	for button in OptionsContainer.get_children():
		button.connect("pressed", self, "_on_Button_pressed", [button.name])


# If an option is pressed
func _on_Button_pressed(name):
	match name:
		"DailyLogin":
			_display_event(0)
		"Events":
			_display_event(1)
		"SeasonDescription":
			_display_event(2)
		"WorldAchievements":
			_display_event(3)
		"StateAchievements":
			_display_event(4)


# Displays the proper panel
func _display_event(event_index):
	for index in range(len(Events)):
		if index == event_index:
			Events[index].show()
		else:
			Events[index].hide()


# Shows the Events UI
func _on_Events_pressed():
	show()


# Hides the Events UI
func _on_CloseEvents_pressed():
	hide()
