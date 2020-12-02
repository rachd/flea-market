extends VBoxContainer


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
	$FleasTab.on_order_fulfilled(flea_ids)
	$OrdersTab.on_order_fulfilled(order_id)
	$ShopTab.update_funds(price)

func _on_flea_purchased(flea, shop_id):
	$FleasTab.on_flea_purchased(flea)
	$ShopTab.on_flea_purchased(flea, shop_id)
