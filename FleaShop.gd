extends HBoxContainer

signal flea_purchased(flea, shop_id)

var id
var flea

func check_enabled():
	$Button.disabled = GameVariables.cents < flea.price

func populate(flea, id):
	self.id = id
	self.flea = flea
	if flea.genes[0] == 0:
		$SexLabel.text = "F"
	else:
		$SexLabel.text = "M"
	$VBoxContainer/SizeLabel.text = str(Evolution.calculate_size(flea.genes))
	$PriceLabel.text = str(flea.price) + " cents"
	check_enabled()

func _ready():
	self.connect("flea_purchased", get_node("/root/Game"), "_on_flea_purchased")

func _on_Button_pressed():
	emit_signal("flea_purchased", self.flea, id)
