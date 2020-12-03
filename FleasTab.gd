extends VBoxContainer

var flea_scene = preload("res://Flea.tscn")
var flea_children = {}
var time_since_last_child = 0

signal flea_born(flea_id)

func _ready():
	self.connect("flea_born", get_node("/root/Game"), "_on_flea_born")
	GameVariables.population = Evolution.generate_initial_population()
	for p in GameVariables.population.keys():
		_add_flea(p)

func on_flea_die(id):
	GameVariables.population.erase(id)
	flea_children[id].queue_free()
	flea_children.erase(id)
	_set_population_label()
	
func _set_population_label():
	$PopulationLabel.text = "Population: " + str(GameVariables.population.size()) + "/20"
	
func _add_flea(flea_id):
	var flea = flea_scene.instance()
	flea.populate(GameVariables.population[flea_id], flea_id)
	$ScrollContainer/FleaContainer.add_child(flea)
	flea_children[flea_id] = flea
	_set_population_label()

func _on_ReproduceTimer_timeout():
	time_since_last_child += 1
	if time_since_last_child >= 20 - (GameVariables.population.size() / 2) and Evolution.can_reproduce():
		var child = Evolution.reproduce(GameVariables.population)
		GameVariables.population[child.id] = child.value
		_add_flea(child.id)
		emit_signal("flea_born", child.id)
		time_since_last_child = 0

func on_order_fulfilled(ids):
	for id in ids:
		GameVariables.population.erase(id)
		flea_children[id].queue_free()
		flea_children.erase(id)
		_set_population_label()
		
func on_flea_purchased(flea):
	var flea_id = Evolution.assign_id()
	GameVariables.population[flea_id] = flea.genes
	_add_flea(flea_id)

func close_tab():
	self.hide()
