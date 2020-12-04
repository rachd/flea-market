extends VBoxContainer

signal advertise()

var order_scene = preload("res://Order.tscn")
var order_children = {}
var advertise_progress = 0

func _ready():
	_add_order()
	_add_order()
	self.connect("advertise", get_node("/root/Game"), "_on_advertise")
	
func _on_open_fulfill(order_id):
	$OrderFulfillment.populate(order_id, order_children[order_id].time_left)
	$ScrollContainer.hide()
	$AdvertiseContainer.hide()

func _on_close_fulfill():
	$OrderFulfillment.hide()
	$ScrollContainer.show()
	$AdvertiseContainer.show()
	
func on_order_fulfilled(order_id):
	remove_order(order_id)
	$AdvertiseContainer/AdvertiseButton.disabled = GameVariables.cents < 3
	
func on_flea_purchased():
	$AdvertiseContainer/AdvertiseButton.disabled = GameVariables.cents < 3

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

func on_flea_born(flea_id):
	$OrderFulfillment.refresh()
	
func on_flea_die(flea_id):
	$OrderFulfillment.on_flea_die(flea_id)
	
func on_advertise():
	$AdvertiseContainer/AdvertiseButton.disabled = GameVariables.cents < 3

func _on_AdvertiseButton_pressed():
	$AdvertiseContainer/AdvertiseButton.hide()
	advertise_progress = 0
	$AdvertiseContainer/TextureProgress.value = 0
	$AdvertiseContainer/TextureProgress.show()
	$AdvertiseContainer/AdvertiseProgressTimer.start()
	emit_signal("advertise")

func _on_AdvertiseProgressTimer_timeout():
	advertise_progress += 1
	$AdvertiseContainer/TextureProgress.value = advertise_progress
	if advertise_progress == 100:
		_add_order()
		_add_order()
		$AdvertiseContainer/AdvertiseProgressTimer.stop()
		$AdvertiseContainer/TextureProgress.hide()
		$AdvertiseContainer/AdvertiseButton.show()
