extends Panel


var building_levels
var tax_panels
var tax_count

onready var government_panel = $"../../../GovernmentUI/GovernmentPanel"
onready var error_panel = $ErrorPanel
onready var collect_taxes_button = $CollectTaxes
onready var tax_boxes = $TaxBoxes


func _ready():
	tax_panels = tax_boxes.get_children()
	tax_count = 0


# Checks the tax building so the player can collect taxes or not
func check_tax_building():
	building_levels = government_panel.get_building_levels()
	
	if building_levels["Taxes"] > 0:
		tax_boxes.show()
		error_panel.hide()
	else:
		tax_boxes.hide()
		error_panel.show()


# Collect taxes
func _on_CollectTaxes_pressed():
	if tax_count < 3:
		var tax = tax_panels[tax_count]
		var collected = tax.get_node("Collected")
		
		collected.show()
		tax_count = tax_count + 1
	
	if tax_count == 3:
		collect_taxes_button.disabled = true
