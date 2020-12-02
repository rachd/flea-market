extends HBoxContainer

var id

signal add_flea(id)
signal remove_flea(id)

func populate(genes, id):
	self.id = id
	if genes[0] == 0:
		$SexLabel.text = "F"
	else:
		$SexLabel.text = "M"
	$VBoxContainer/SizeLabel.text = str(Evolution.calculate_size(genes))

func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		emit_signal("add_flea", id)
	else:
		emit_signal("remove_flea", id)
		
func _ready():
	self.connect("add_flea", get_node("/root/Game/OrdersTab/OrderFulfillment"), "_on_add_flea")
	self.connect("remove_flea", get_node("/root/Game/OrdersTab/OrderFulfillment"), "_on_remove_flea")
