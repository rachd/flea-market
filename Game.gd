extends VBoxContainer

func _ready():
	set_funds_text()

func _on_OrdersButton_pressed():
	$ShopTab.close_tab()
	$FleasTab.close_tab()
	$OrdersTab.show()

func _on_FleasButton_pressed():
	$ShopTab.close_tab()
	$FleasTab.show()
	$OrdersTab.close_tab()

func _on_ShopButton_pressed():
	$ShopTab.show()
	$FleasTab.close_tab()
	$OrdersTab.close_tab()

func _on_order_fulfilled(flea_ids, order_id, price):
	GameVariables.cents += price
	set_funds_text()
	$FleasTab.on_order_fulfilled(flea_ids)
	$OrdersTab.on_order_fulfilled(order_id)
	$ShopTab.update_funds()

func _on_flea_purchased(flea, shop_id):
	GameVariables.cents -= flea.price
	set_funds_text()
	$FleasTab.on_flea_purchased(flea)
	$ShopTab.on_flea_purchased(flea, shop_id)
	$OrdersTab.on_flea_purchased()
	
func _on_flea_born(flea_id):
	$OrdersTab.on_flea_born(flea_id)
	
func _on_flea_die(flea_id):
	$FleasTab.on_flea_die(flea_id)
	$OrdersTab.on_flea_die(flea_id)
	
func _on_advertise():
	GameVariables.cents -= 3
	set_funds_text()
	$OrdersTab.on_advertise()
	
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
		$FundsLabel.text = formattedCents + " cent"
	else:
		$FundsLabel.text = formattedCents + " cents"
