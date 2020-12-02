extends VBoxContainer

var flea_scene = preload("res://Flea.tscn")
var flea_children = {}

func _ready():
	GameVariables.population = Evolution.generate_initial_population()
	for p in GameVariables.population.keys():
		_add_flea(p)

func _on_flea_die(id):
	GameVariables.population.erase(id)
	flea_children[id].queue_free()
	flea_children.erase(id)
	
func _add_flea(flea_id):
	var flea = flea_scene.instance()
	flea.populate(GameVariables.population[flea_id], flea_id)
	$ScrollContainer/FleaContainer.add_child(flea)
	flea_children[flea_id] = flea

func _on_ReproduceTimer_timeout():
	if Evolution.can_reproduce():
		var child = Evolution.reproduce(GameVariables.population)
		GameVariables.population[child.id] = child.value
		_add_flea(child.id)

func on_order_fulfilled(ids):
	for id in ids:
		GameVariables.population.erase(id)
		flea_children[id].queue_free()
		flea_children.erase(id)
		
func on_flea_purchased(flea):
	var flea_id = Evolution.assign_id()
	GameVariables.population[flea_id] = flea.genes
	_add_flea(flea_id)

func close_tab():
	self.hide()
