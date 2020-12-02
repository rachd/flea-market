extends HBoxContainer

signal die(id)

var age = 1
var max_age
var id

func _ready():
	self.connect("die", get_node("/root/Game/FleasTab"), "_on_flea_die")

func populate(genes, id):
	self.id = id
	if genes[0] == 0:
		$SexLabel.text = "F"
	else:
		$SexLabel.text = "M"
	$VBoxContainer/SizeLabel.text = str(Evolution.calculate_size(genes))
	$VBoxContainer2/AgeLabel.text = str(age)
	max_age = round(genes[2])

func _on_AgeTimer_timeout():
	age += 1
	$VBoxContainer2/AgeLabel.text = str(age)
	if age == max_age:
		die()
		
func die():
	emit_signal("die", id)

func _on_ReleaseButton_pressed():
	self.die()
