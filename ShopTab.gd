extends VBoxContainer

var flea_scene = preload("res://FleaShop.tscn")
var shop_children = {}

func _ready():
	update_funds()
	_add_order()

func update_funds(price = 0):
	GameVariables.cents += price
	$FundsLabel.text = str(GameVariables.cents) + " cents"
	for child in shop_children:
		shop_children[child].check_enabled()
		
func on_flea_purchased(flea, shop_id):
	GameVariables.cents -= flea.price
	update_funds()
	GameVariables.shop_items.erase(shop_id)
	shop_children[shop_id].queue_free()
	shop_children.erase(shop_id)

func close_tab():
	self.hide()
	
func _on_Timer_timeout():
	_add_order()
	
func _add_order():
	var flea_instance = flea_scene.instance()
	var flea = ShopHelper.generate_flea_for_sale()
	GameVariables.shop_items[flea.key] = flea.value
	flea_instance.populate(flea.value, flea.key)
	$ScrollContainer/ItemsContainer.add_child(flea_instance)
	shop_children[flea.key] = flea_instance
