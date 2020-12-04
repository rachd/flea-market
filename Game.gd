extends MarginContainer

func _ready():
	set_funds_text()

func _on_OrdersButton_pressed():
	$VBoxContainer/ShopTab.close_tab()
	$VBoxContainer/FleasTab.close_tab()
	$VBoxContainer/OrdersTab.show()

func _on_FleasButton_pressed():
	$VBoxContainer/ShopTab.close_tab()
	$VBoxContainer/FleasTab.show()
	$VBoxContainer/OrdersTab.close_tab()

func _on_ShopButton_pressed():
	$VBoxContainer/ShopTab.show()
	$VBoxContainer/FleasTab.close_tab()
	$VBoxContainer/OrdersTab.close_tab()

func _on_order_fulfilled(flea_ids, order_id, price):
	GameVariables.cents += price
	set_funds_text()
	$VBoxContainer/FleasTab.on_order_fulfilled(flea_ids)
	$VBoxContainer/OrdersTab.on_order_fulfilled(order_id)
	$VBoxContainer/ShopTab.update_funds()

func _on_flea_purchased(flea, shop_id):
	GameVariables.cents -= flea.price
	set_funds_text()
	$VBoxContainer/FleasTab.on_flea_purchased(flea)
	$VBoxContainer/ShopTab.on_flea_purchased(flea, shop_id)
	$VBoxContainer/OrdersTab.on_flea_purchased()
	
func _on_flea_born(flea_id):
	$VBoxContainer/OrdersTab.on_flea_born(flea_id)
	
func _on_flea_die(flea_id):
	$VBoxContainer/FleasTab.on_flea_die(flea_id)
	$VBoxContainer/OrdersTab.on_flea_die(flea_id)
	
func _on_advertise():
	GameVariables.cents -= 3
	set_funds_text()
	$VBoxContainer/OrdersTab.on_advertise()
	
func format(n):
	n = str(n)
	var size = n.length()
	var s = ""
	
	for i in range(size):
			if((size - i) % 3 == 0 and i > 0):
				s = str(s,",", n[i])
			else:
				s = str(s,n[i])
			
	return s
	
func set_funds_text():
	var formattedCents = format(GameVariables.cents)
	if GameVariables.cents == 1:
		$VBoxContainer/FundsLabel.text = formattedCents + " cent"
	else:
		$VBoxContainer/FundsLabel.text = formattedCents + " cents"
