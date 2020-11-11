extends Control


var infrastructure_labels = []

onready var infra_info_panel = $InfrastrucutreInfo/InfoPanel


# Dims the background of the UI
func dim_background(color):
	
	for node in self.get_children():
		if node != $InfrastrucutreInfo:
			node.set_modulate(color)


# Shows the GovernmentUI
func _on_Government_pressed():
	show()


# Hides the current panel
func _on_CloseGovernment_pressed():
	infra_info_panel.hide()
	hide()
