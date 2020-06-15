extends Button


export(int) var day
export(Array, String) var type
export(Array, int) var amount
export(int) var z_index

onready var node2D = $Node2D
onready var description = $Node2D/Description
onready var timer = $Node2D/Description/Timer
onready var button_sprite = $Sprite
onready var resources_container = $Node2D/Description/Type
onready var day_label = $Day

var resources


func _ready():
	_get_buttons()
	_get_resources()
	_set_up_sprite()
	_set_up_resources()


# Gets the buttons and z index
func _get_buttons():
	# warning-ignore:return_value_discarded
	self.connect("pressed", self, "_on_Daily_pressed", [description])
	description.connect("pressed", self, "_on_Description_pressed", [description])


# When a daily is pressed, show the description
func _on_Daily_pressed(button):
	button.show()
	self.disabled = true


# When the description is pressed, hide the description
func _on_Description_pressed(button):
	button.hide()
	timer.start()


# Gets resources
func _get_resources():
	resources = resources_container.get_children()


# Sets up the daily button
func _set_up_sprite():
	day_label.text = str(day)
	node2D.z_index = z_index
	
	_match_image(type[0], button_sprite, false)


# Sets up the resources
func _set_up_resources():
	for index in range(len(type)):
		var sprite_holder = resources[index].get_node("SpriteHolder")
		var sprite = sprite_holder.get_node("Sprite")
		var count = resources[index].get_node("Count")
		
		resources[index].show()
		count.text = str(amount[index])
		
		_match_image(type[index], sprite, true)


# Matches the images to the resource
func _match_image(image, sprite, is_resource):
	match image:
		"Gems":
			if is_resource:
				sprite.set_offset(Vector2(75, 50))
			sprite.texture = load("res://Sprites/GameUISprites/Gems.png")
		"Gold":
			if is_resource:
				sprite.set_offset(Vector2(100, 75))
			sprite.texture = load("res://Sprites/GameUISprites/Gold.png")
		"Wood":
			if is_resource:
				sprite.set_offset(Vector2(0, 75))
			sprite.texture = load("res://Sprites/GameUISprites/Wood.png")
		"Stone":
			sprite.texture = load("res://Sprites/GameUISprites/Stone.png")
		"Food":
			if is_resource:
				sprite.set_offset(Vector2(25, 75))
			sprite.texture = load("res://Sprites/GameUISprites/Food.png")
		"Decree":
			if is_resource:
				sprite.set_offset(Vector2(25, 75))
			sprite.texture = load("res://Sprites/GameUISprites/Decrees.png")


# When it is clicked outside the description, hide the description
func _input(event):
	
	var x1 = description.rect_position.x
	var x2 = description.rect_size.x + x1
	var y1 = description.rect_position.y
	var y2 = description.rect_size.y + y1
	
	if description.is_visible():
		if event is InputEventMouseButton:
			if event.position.x < x1 or event.position.x > x2 or \
					event.position.y < y1 or event.position.y > y2:
				description.emit_signal("pressed")


# When the timer runs out, enable the daily button
func _on_Timer_timeout():
	self.disabled = false
