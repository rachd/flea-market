extends Node

var rng = RandomNumberGenerator.new()

var id = 0

func generate_flea_for_sale():
	var flea = {}
	flea["genes"] = Evolution.generate_member()
	flea["price"] = rng.randi_range(1, 3)
	id += 1
	return {"key": id, "value": flea}
	
func _ready():
	rng.randomize()
