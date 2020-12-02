extends VBoxContainer

var order_scene = preload("res://Order.tscn")
var order_children = {}

func _ready():
	_add_order()
	_add_order()
	
func _on_open_fulfill(order_id):
	$OrderFulfillment.populate(order_id, order_children[order_id].time_left)
	$ScrollContainer.hide()

func _on_close_fulfill():
	$OrderFulfillment.hide()
	$ScrollContainer.show()
	
func on_order_fulfilled(order_id):
	remove_order(order_id)

func remove_order(order_id):
	GameVariables.orders.erase(order_id)
	order_children[order_id].queue_free()
	order_children.erase(order_id)
	
func _on_expired(order_id):
	remove_order(order_id)

func _on_Timer_timeout():
	_add_order()
	
func _add_order():
	var order_instance = order_scene.instance()
	var order = OrderHelper.generate_order()
	GameVariables.orders[order.id] = order.value
	order_instance.populate(order.id)
	$ScrollContainer/OrderContainer.add_child(order_instance)
	order_children[order.id] = order_instance
	
func close_tab():
	$OrderFulfillment.close()
	self.hide()
