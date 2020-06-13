extends Control


# Variable to get the buttons for skills
onready var SkillOptions = $SkillsContainerOptions

# Keeps track of the skill type
var skill_type


# Gets the buttons
func _ready():
	for skill_button in SkillOptions.get_children():
		skill_button.connect("pressed", self, "_on_Button_pressed", [skill_button])


# Sets the skill type
func _on_Button_pressed(skill_button):
	skill_type = skill_button.text


# Shows the Skills UI
func _on_Skills_pressed():
	show()


# Hides the Skills UI
func _on_CloseSkills_pressed():
	hide()
