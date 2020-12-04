extends VBoxContainer

var flea_scene = preload("res://FleaShop.tscn")
var shop_children = {}

func _ready():
	update_funds()
	_refresh_fleas()

func update_funds():
	for child in shop_children:
		shop_children[child].check_enabled()
	$HBoxContainer2/RetireButton.disabled = GameVariables.cents < 1000000
		
func on_flea_purchased(flea, shop_id):
	update_funds()
	GameVariables.shop_items.erase(shop_id)
	shop_children[shop_id].queue_free()
	shop_children.erase(shop_id)

func close_tab():
	self.hide()
	
func _on_Timer_timeout():
	_refresh_fleas()
	
func _refresh_fleas():
	for c in shop_children.keys():
		GameVariables.shop_items.erase(c)
		shop_children[c].queue_free()
		shop_children.erase(c)
	for i in range(4):
		var flea_instance = flea_scene.instance()
		var flea = ShopHelper.generate_flea_for_sale()
		GameVariables.shop_items[flea.key] = flea.value
		flea_instance.populate(flea.value, flea.key)
		$ScrollContainer/ItemsContainer.add_child(flea_instance)
		shop_children[flea.key] = flea_instance


func _on_RetireButton_pressed():
	get_tree().change_scene("res://EndScreen.tscn")
