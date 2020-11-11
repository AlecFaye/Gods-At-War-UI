extends Control


# Keeps track of the skill type
var skill_type
var current_panel
var skill_panels
var skill_index

# Enum for skill panels
enum {ATTACK, SPECIAL, CONTROL, DEFENSIVE, HEAL, STATISTICAL, CONQUEST}

# Variable to get the buttons for skills
onready var SkillOptions = $SkillsContainerOptions


# Gets the buttons
func _ready():
	skill_panels = [$AttackPanel, $SpecialPanel, $ControlPanel, $DefensivePanel, $HealPanel, $StatisticalPanel, $ConquestPanel]
	current_panel = skill_panels[ATTACK]
	
	for skill_button in SkillOptions.get_children():
		skill_button.connect("pressed", self, "_on_Button_pressed", [skill_button])


# Sets the skill type
func _on_Button_pressed(skill_button):
	skill_type = skill_button.text
	
	match skill_type:
		"Attack":
			current_panel = skill_panels[ATTACK]
		"Special":
			current_panel = skill_panels[SPECIAL]
		"Control":
			current_panel = skill_panels[CONTROL]
		"Defensive":
			current_panel = skill_panels[DEFENSIVE]
		"Heal":
			current_panel = skill_panels[HEAL]
		"Statistical":
			current_panel = skill_panels[STATISTICAL]
		"Conquest":
			current_panel = skill_panels[CONQUEST]
	
	show_hide_panels()


# Shows the Skills UI
func _on_Skills_pressed():
	show_hide_panels()
	show()


# Shows and hides the current panels
func show_hide_panels():
	for panel in skill_panels:
		if current_panel != panel:
			panel.hide()
	current_panel.show()


# Hides the Skills UI
func _on_CloseSkills_pressed():
	hide()


# Dims the background of the UI
func dim_background(color):
	
	for node in self.get_children():
		if node != $SkillInfo2DNode:
			node.set_modulate(color)
