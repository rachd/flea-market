extends HBoxContainer

signal die(id)

var age = 1
var max_age
var id
var train_progress = 0

func _ready():
	self.connect("die", get_node("/root/Game"), "_on_flea_die")

func populate(genes, id):
	self.id = id
	if genes[0] == 0:
		$SexLabel.text = "F"
	else:
		$SexLabel.text = "M"
	$SizeLabel.text = str(Evolution.calculate_size(genes))
	$ObedienceLabel.text = Evolution.calculate_obedience(genes)
	$AgeLabel.text = str(age)
	max_age = round(genes[2])

func _on_AgeTimer_timeout():
	age += 1
	if GameVariables.population[id][3] >= -0.76:
		GameVariables.population[id][3] -= 0.04
	$ObedienceLabel.text = Evolution.calculate_obedience(GameVariables.population[id])
	$AgeLabel.text = str(age)
	if age == max_age:
		die()
		
func die():
	emit_signal("die", id)

func _on_ReleaseButton_pressed():
	self.die()

func _on_TrainButton_pressed():
	$Control/TrainTimer.start()
	$Control/TextureProgress.show()
	$Control/TrainButton.hide()

func _on_TrainTimer_timeout():
	train_progress += 1
	$Control/TextureProgress.value = train_progress
	if train_progress == 100:
		$Control/TrainTimer.stop()
		if GameVariables.population[id][3] <= 1.1:
			GameVariables.population[id][3] += 0.1
		$ObedienceLabel.text = Evolution.calculate_obedience(GameVariables.population[id])
		train_progress = 0
		$Control/TextureProgress.value = 0
		$Control/TextureProgress.hide()
		$Control/TrainButton.show()
