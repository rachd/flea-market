extends VBoxContainer

signal close_fulfill
signal order_fulfilled(selected_fleas, order_id, price)

var order_id
var order
var flea_scene = preload("res://FleaOrder.tscn")
var selected_ids = []

func populate(o_id, time_left):
	order_id = o_id
	order = GameVariables.orders[order_id]
	$Order.populate(order_id, time_left)
	var matches = find_matching_fleas()
	for id in matches.keys():
		var flea = flea_scene.instance()
		flea.populate(matches[id], id)
		$ScrollContainer/FleaContainer.add_child(flea)
	self.show()

func find_matching_fleas():
	var matches = {}
	for flea in GameVariables.population.keys():
		var traitValue;
		if order.trait == "sex":
			traitValue = GameVariables.population[flea][0]
		elif order.trait == "size":
			traitValue = Evolution.calculate_size(GameVariables.population[flea])
		if (!order.has("max") or traitValue <= order.max) and (!order.has("min") or traitValue >= order.min):
			matches[flea] = GameVariables.population[flea]
	return matches

func _ready():
	self.connect("close_fulfill", get_node("/root/Game/OrdersTab"), "_on_close_fulfill")
	self.connect("order_fulfilled", get_node("/root/Game"), "_on_order_fulfilled")
	
func _on_CloseButton_pressed():
	close()
	
func close():
	for child in $ScrollContainer/FleaContainer.get_children():
		child.queue_free()
	selected_ids = []
	_enable_disable_button()
	emit_signal("close_fulfill")
	
func _enable_disable_button():
	if order and selected_ids.size() == order.quantity:
		$FulfillButton.disabled = false
	else:
		$FulfillButton.disabled = true
	
func _on_add_flea(id):
	selected_ids.append(id)
	_enable_disable_button()
	
func _on_remove_flea(id):
	selected_ids.erase(id)
	_enable_disable_button()

func _on_FulfillButton_pressed():
	emit_signal("order_fulfilled", selected_ids, order_id, order.price)
	close()
