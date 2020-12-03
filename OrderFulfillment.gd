extends VBoxContainer

signal close_fulfill
signal order_fulfilled(selected_fleas, order_id, price)

var order_id
var order
var flea_scene = preload("res://FleaOrder.tscn")
var fleas_shown = {}
var selected_ids = []

func populate(o_id, time_left):
	order_id = o_id
	order = GameVariables.orders[order_id]
	$Order.populate(order_id, time_left)
	var matches = find_matching_fleas()
	for id in matches.keys():
		_add_flea(matches[id], id)
	if matches.size() == 0:
		$NoFleasLabel.show()
	$FulfillButton.text = "Fulfill - " + str(selected_ids.size()) + "/" + str(order.quantity)
	self.show()
	
func refresh():
	if order:
		var matches = find_matching_fleas()
		for id in matches.keys():
			if !id in fleas_shown.keys():
				_add_flea(matches[id], id)
	
func _add_flea(flea, id):
	$NoFleasLabel.hide()
	var flea_instance = flea_scene.instance()
	flea_instance.populate(flea, id)
	$ScrollContainer/FleaContainer.add_child(flea_instance)
	fleas_shown[id] = flea_instance

func find_matching_fleas():
	var matches = {}
	for flea in GameVariables.population.keys():
		var traitValue;
		if order.trait == "sex":
			traitValue = GameVariables.population[flea][0]
		elif order.trait == "size":
			traitValue = Evolution.calculate_size(GameVariables.population[flea])
		elif order.trait == "obedience":
			traitValue = round(GameVariables.population[flea][3])
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
	order = null
	order_id = null
	fleas_shown = {}
	_enable_disable_button()
	$NoFleasLabel.hide()
	emit_signal("close_fulfill")
				
func on_flea_die(flea_id):
	if order and flea_id in fleas_shown.keys():
		fleas_shown[flea_id].queue_free()
		fleas_shown.erase(flea_id)
		if flea_id in selected_ids:
			selected_ids.erase(flea_id)
			_enable_disable_button()
		if fleas_shown.keys().size() == 0:
			$NoFleasLabel.show()
	
func _enable_disable_button():
	if order and selected_ids.size() == order.quantity:
		$FulfillButton.disabled = false
	else:
		$FulfillButton.disabled = true
	
func _on_add_flea(id):
	selected_ids.append(id)
	_enable_disable_button()
	$FulfillButton.text = "Fulfill - " + str(selected_ids.size()) + "/" + str(order.quantity)
	
func _on_remove_flea(id):
	selected_ids.erase(id)
	_enable_disable_button()
	$FulfillButton.text = "Fulfill - " + str(selected_ids.size()) + "/" + str(order.quantity)

func _on_FulfillButton_pressed():
	emit_signal("order_fulfilled", selected_ids, order_id, order.price)
	close()
