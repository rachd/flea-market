extends VBoxContainer

signal open_fulfill(id)
signal expired(id)

export var readOnly = false

var order_id
var time_left = 600

func populate(id, countdown = 600):
	order_id = id
	var order = GameVariables.orders[id]
	$HBoxContainer/QuantityLabel.text = str(order.quantity)
	$HBoxContainer/DescriptionLabel.text = order.description
	$HBoxContainer/PriceLabel.text = str(order.price) + " cents"
	time_left = countdown
	$TextureProgress.value = time_left

func _on_Order_gui_input(event):
	if !readOnly and (event is InputEventMouseButton or event is InputEventScreenTouch) and event.pressed:
		emit_signal("open_fulfill", order_id)
		
func _ready():
	self.connect("open_fulfill", get_node("/root/Game/OrdersTab"), "_on_open_fulfill")
	self.connect("expired", get_node("/root/Game/OrdersTab"), "_on_expired")

func _on_SecondTimer_timeout():
	time_left -= 1
	$TextureProgress.value = time_left
	if time_left == 0 and !readOnly:
		emit_signal("expired", order_id)
