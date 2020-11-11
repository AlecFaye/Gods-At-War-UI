extends Panel


var upgrade_amount
var god_limit
var gods_using_skill
var gods_nodes = []

# Dims the UI when a skill is pressed
var original_color = Color(1, 1, 1, 1)
var dimmed_color = original_color.darkened(0.5)

onready var DebuggerUI = $"../../../Debugger"
onready var SkillUI = $"../.."
onready var learned_by = $VBoxContainer/HBoxContainer/SkillIcon/VBoxContainer


func _ready():
	_set_panel_position()
	DebuggerUI.load_panel_position()
	
	for node in learned_by.get_children():
		if node is Label:
			gods_nodes.append(node)


# Sets the position of the panel
func _set_panel_position():
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	
	var x = width/2 - self.rect_size.x/2
	var y = height/2 - self.rect_size.y/2 + 30
	
	self.rect_position = Vector2(x, y)


# Sets the skill info
func set_skill_info(name, effect, description, damage, type, s_range, rate, is_upgrading_rate, rate_upgrade, target, upgrade, limit, percentage, gods, level, sprite_path):
	var name_label = $VBoxContainer/Panel/SkillName
	name_label.text = name
	
	var effect_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/HBoxContainer1/SkillEffect
	effect_label.text = effect
	
	var type_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/HBoxContainer1/Type
	type_label.text = type
	
	var range_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/HBoxContainer2/Range
	range_label.text = s_range
	
	var current_rate_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/HBoxContainer2/Rate
	if rate != -1:
		var current_rate = rate + level * rate_upgrade
		current_rate_label.text = str(current_rate) + "%"
	else:
		current_rate_label.text = "---"
	
	var next_rate_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/Header3/HBoxContainer/NextRateLabel
	if is_upgrading_rate:
		var rate_calculation = rate + (level + 1) * rate_upgrade
		next_rate_label.text = "(Rate " + str(rate_calculation) + "%)"
	else:
		next_rate_label.text = " "
	
	var target_label = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/HBoxContainer3/Target
	target_label.text = ""
	for index in range(len(target)):
		target_label.text += target[index] + " "
	
	var sprite = $VBoxContainer/HBoxContainer/SkillIcon/VBoxContainer/TextureRect/Sprite
	sprite.texture = load(sprite_path)
	
	var current_level = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/CurrentLevelDescription
	var next_level = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer/VBoxContainer/NextLevelDescription
	
	var current_damage = []
	var next_damage = []
	
	for index in range(len(damage)):
		
		var damage1 = str(damage[index] + level * upgrade[index])
		var damage2 = str(damage[index] + (level + 1) * upgrade[index])
		
		if percentage[index]:
			damage1 += "%"
			damage2 += "%"
		
		current_damage.append(damage1)
		next_damage.append(damage2)
	
	current_level.text = description % current_damage
	next_level.text = description % next_damage
	
	upgrade_amount = upgrade
	god_limit = limit
	gods_using_skill = gods
	
	var scroll_container = $VBoxContainer/HBoxContainer/SkillInfo/ScrollContainer
	var scrollbar = scroll_container.get_v_scrollbar()
	scrollbar.value = scrollbar.min_value
	
	SkillUI.dim_background(dimmed_color)
	show()


# Hides the skill info panel
func _on_CloseSkillInfo_pressed():
	SkillUI.dim_background(original_color)
	hide()


# Also hides the skill info panel
func _input(event):

	if event is InputEventMouseButton:
		var x1 = rect_position.x
		var y1 = rect_position.y
		var x2 = x1 + rect_size.x
		var y2 = y1 + rect_size.y
		
		if event.position.x < x1 or event.position.x > x2 or \
				event.position.y < y1 or event.position.y > y2:
			SkillUI.dim_background(original_color)
			hide()
