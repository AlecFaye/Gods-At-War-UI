extends Timer


onready var resources = $"../GameScreenUI/ResourcePanel"


# Updates all resources
func _on_UpdateTimer_timeout():
	resources.set_special_resources()
