extends Node

var rng = RandomNumberGenerator.new()

var id = 0

var possible_orders = [
	{"description": "Male", "trait": "sex", "min": 1, "max": 1},
	{"description":"Female", "trait": "sex", "min": 0, "max": 0},
	{"description": "At least 3mm in size", "trait": "size", "min": 3},
	{"description": "At least 2mm in size", "trait": "size", "min": 2},
	{"description": "At most 1mm in size", "trait": "size", "max": 1},
	{"description": "At most 2mm in size", "trait": "size", "max": 2},
	{"description": "Between 1.5 and 2.5mm in size", "trait": "size", "min": 1.5, "max": 2.5},
	{"description": "Good or very good obedience", "trait": "obedience", "min": 0.4, "max": 1.2},
	{"description": "Very good obedience", "trait": "obedience", "min": 0.8, "max": 1.2}
]

func generate_order():
	var order_template = possible_orders[rng.randi_range(0, possible_orders.size() - 1)]
	var order = {}
	order["description"] = order_template.description
	order["trait"] = order_template.trait
	if order_template.has("min"):
		order["min"] = order_template.min
	if order_template.has("max"):
		order["max"] = order_template.max
	order["price"] = rng.randi_range(1, 4)
	order["quantity"] = rng.randi_range(2, 6)
	id += 1
	return {"id": id, "value": order}
	
func _ready():
	rng.randomize()
